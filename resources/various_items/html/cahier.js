/* ============================================================================
   Cahier de notes — NUI logic

   • Pas de framework, vanilla JS → 0 dépendance, init instantané.
   • Pas de polling ni setInterval : tout est piloté par les events client Lua
     (`cahier:open` / `cahier:close` / `cahier:saveAck`) et par les inputs DOM.
   • Le Save n'est envoyé QUE sur clic explicite ou Esc/Close → pas de spam de
     keystrokes vers le serveur.
============================================================================ */

(function () {
    "use strict";

    const root        = document.getElementById("cahier-root");
    const titleInput  = document.getElementById("cahier-title");
    const contentArea = document.getElementById("cahier-content");
    const counter     = document.getElementById("cahier-count");
    const savedAt     = document.getElementById("cahier-saved-at");
    const saveBtn     = document.getElementById("cahier-save");
    const closeBtn    = document.getElementById("cahier-close");
    const toast       = document.getElementById("cahier-toast");

    let state = {
        id:           null,
        initialTitle:  "",
        initialContent:"",
        dirty:        false,
        saving:       false,
        maxLength:    5000,
        maxTitle:     60,
        readonly:     false,
    };

    /* -- Resource name helper (pour fetch NUI) ----------------------------- */
    const RESOURCE = (typeof GetParentResourceName === "function")
        ? GetParentResourceName()
        : "various_items";

    function postCallback(action, payload) {
        return fetch(`https://${RESOURCE}/${action}`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify(payload || {}),
        }).catch(() => { /* NUI offline → ignore */ });
    }

    /* -- UI helpers -------------------------------------------------------- */
    function show()  {
        root.classList.remove("cahier-hidden");
        root.setAttribute("aria-hidden", "false");
    }
    function hide() {
        root.classList.add("cahier-hidden");
        root.setAttribute("aria-hidden", "true");
        // Petit délai avant de notifier le client Lua : laisse jouer la transition
        setTimeout(() => postCallback("cahier:close", {}), 180);
    }

    function updateCounter() {
        const n = contentArea.value.length;
        counter.textContent = n;
        counter.parentElement.classList.toggle("cahier-counter-warn", n > state.maxLength * 0.9);
    }

    function markDirty() {
        if (!state.dirty) {
            state.dirty = true;
            savedAt.textContent = "Modifications non sauvegardées";
        }
    }

    function setSavedLabel(ts) {
        if (!ts) {
            savedAt.textContent = "";
            return;
        }
        const d = new Date(ts * 1000);
        savedAt.textContent =
            "Sauvegardé le " +
            d.toLocaleDateString("fr-FR") +
            " à " +
            d.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" });
    }

    function showToast(text, isError) {
        toast.textContent = text;
        toast.classList.toggle("cahier-toast-error", !!isError);
        toast.classList.add("cahier-toast-show");
        clearTimeout(showToast._t);
        showToast._t = setTimeout(() => toast.classList.remove("cahier-toast-show"), 1800);
    }

    /* -- Read-only toggle -------------------------------------------------- */
    function applyReadOnly(on) {
        state.readonly = !!on;
        titleInput.readOnly   = state.readonly;
        contentArea.readOnly  = state.readonly;
        // Le bouton Sauvegarder n'a aucun sens pour le lecteur → on le cache.
        saveBtn.style.display = state.readonly ? "none" : "";
        root.classList.toggle("cahier-readonly", state.readonly);
    }

    /* -- Save flow --------------------------------------------------------- */
    function doSave() {
        if (state.readonly) return;
        if (state.saving || !state.id) return;
        state.saving = true;
        saveBtn.classList.add("cahier-btn-saving");

        postCallback("cahier:save", {
            title:   titleInput.value || "",
            content: contentArea.value || "",
        });

        // Filet de sécurité au cas où l'ack serveur n'arriverait jamais
        // (ressource server arrêtée pile au mauvais moment, etc.)
        clearTimeout(doSave._t);
        doSave._t = setTimeout(() => {
            if (state.saving) {
                state.saving = false;
                saveBtn.classList.remove("cahier-btn-saving");
            }
        }, 4000);
    }

    function attemptCloseWithSave() {
        if (!state.readonly && state.dirty) {
            doSave();
            // On laisse le close visible immédiatement (pas de blocking dialog)
            // mais le save part quand même côté serveur.
        }
        hide();
    }

    /* -- Event wiring (DOM) ------------------------------------------------ */
    titleInput.addEventListener("input", () => {
        if (titleInput.value.length > state.maxTitle) {
            titleInput.value = titleInput.value.slice(0, state.maxTitle);
        }
        markDirty();
    });

    contentArea.addEventListener("input", () => {
        if (contentArea.value.length > state.maxLength) {
            contentArea.value = contentArea.value.slice(0, state.maxLength);
        }
        updateCounter();
        markDirty();
    });

    saveBtn.addEventListener("click", doSave);
    closeBtn.addEventListener("click", attemptCloseWithSave);

    document.addEventListener("keydown", (e) => {
        if (root.classList.contains("cahier-hidden")) return;

        // Esc → close + auto-save si dirty
        if (e.key === "Escape") {
            e.preventDefault();
            attemptCloseWithSave();
            return;
        }

        // Ctrl/Cmd + S → save
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "s") {
            e.preventDefault();
            doSave();
            return;
        }
    });

    /* -- Bridge depuis le client Lua -------------------------------------- */
    window.addEventListener("message", (event) => {
        const msg = event.data || {};

        if (msg.type === "cahier:open") {
            state.id             = msg.id || null;
            state.initialTitle   = msg.title || "";
            state.initialContent = msg.content || "";
            state.dirty          = false;
            state.saving         = false;
            state.maxLength      = msg.maxLength || 5000;
            state.maxTitle       = msg.maxTitle  || 60;

            titleInput.value   = state.initialTitle;
            contentArea.value  = state.initialContent;
            updateCounter();

            applyReadOnly(!!msg.readonly);

            if (msg.readonly && msg.from) {
                // En mode visualisation, on remplace le label "sauvegardé le ..."
                // par l'origine du cahier (qui le montre).
                savedAt.textContent = "Cahier de " + msg.from;
            } else {
                setSavedLabel(msg.updatedAt);
            }
            saveBtn.classList.remove("cahier-btn-saving");

            show();

            // Focus : titre vide → titre, sinon contenu. En readonly, ne pas focus
            // le titre (pas d'édition possible) → focus le contenu pour scroll.
            setTimeout(() => {
                if (state.readonly) {
                    contentArea.focus();
                } else if (state.initialTitle === "") {
                    titleInput.focus();
                } else {
                    contentArea.focus();
                }
            }, 80);
            return;
        }

        if (msg.type === "cahier:close") {
            hide();
            return;
        }

        if (msg.type === "cahier:saveAck") {
            state.saving = false;
            saveBtn.classList.remove("cahier-btn-saving");

            if (msg.ok) {
                state.dirty = false;
                setSavedLabel(Math.floor(Date.now() / 1000));
                showToast("Sauvegardé", false);
            } else {
                showToast("Erreur : sauvegarde refusée", true);
            }
            return;
        }
    });
})();
