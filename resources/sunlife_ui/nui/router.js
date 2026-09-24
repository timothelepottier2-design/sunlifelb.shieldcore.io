/*
 * sunlife_ui - Routeur NUI
 * --------------------------------------------------------------------------
 * Une seule resource FiveM ne peut avoir qu'un seul ui_page. Cette page est ce
 * point d'entree unique : elle heberge chaque app fusionnee dans sa propre
 * iframe (isolation CSS/JS totale) et route les messages.
 *
 * Cote Lua, chaque app utilise un prelude (shared/sl_prelude... applique en tete
 * de fichier) qui :
 *   - enveloppe SendNUIMessage  -> { _slapp = '<app>', _slpayload = data }
 *   - enveloppe SetNuiFocus      -> message de controle { _slrouter, _slapp, focus }
 *   - prefixe RegisterNUICallback -> '<app>/<name>'  (les fetch JS ciblent
 *                                    https://sunlife_ui/<app>/<name>)
 *
 * Le routeur transmet _slpayload a la bonne iframe et gere le focus (z-index +
 * pointer-events). Les iframes sont creees a la demande (lazy) pour optimiser.
 */
(function () {
  "use strict";

  // app -> chemin HTML (relatif a nui/)
  var APPS = {
    bank: "../apps/bank/client/html/UI.html",
    boutique: "../apps/boutique/html/shops.html",
    charcreator: "../apps/charcreator/html/shops.html",
    clothesshop: "../apps/clothesshop/html/shops.html",
    dispatch: "../apps/dispatch/html/shops.html",
    dmvschool: "../apps/dmvschool/html/shops.html",
    fishing: "../apps/fishing/html/shops.html",
    garage: "../apps/garage/html/shops.html",
    gunfight: "../apps/gunfight/hud/hud.html",
    illtablet: "../apps/illtablet/html/index.html",
    location: "../apps/location/html/shops.html",
    poltablet: "../apps/poltablet/ui/index.html",
    quest: "../apps/quest/html/index.html",
    staffui: "../apps/staffui/html/interface.html",
    weedpots: "../apps/weedpots/html/shops.html",
    merged: "../apps/merged/html/interface.html"
  };

  // Apps a pre-charger au demarrage (iframe creee tout de suite, pas a la
  // demande). Indispensable pour gunfight : son hud.html charge de grosses
  // ressources externes (tesseract, jQuery/FontAwesome CDN) ; en lazy, le
  // 1er message "openLobby" arrivait avant la fin du chargement et etait
  // perdu/retarde (le curseur s'affichait mais pas le panneau). En standalone
  // cette page etait l'ui_page, donc toujours prechargee.
  // merged = HUD overlay permanent (statushud/speedo/koth/gym), comme gunfight
  // c'etait une ui_page toujours prechargee en standalone.
  var EAGER = ["gunfight", "merged"];

  var frames = {}; // app -> { el, ready, queue }
  var root = null;
  var activeFocus = null;

  function getRoot() {
    if (!root) root = document.getElementById("sl-root") || document.body;
    return root;
  }

  function ensure(app) {
    if (frames[app]) return frames[app];
    var src = APPS[app];
    if (!src) {
      console.warn("[sunlife_ui] app inconnue:", app);
      return null;
    }
    var el = document.createElement("iframe");
    el.className = "sl-frame";
    el.setAttribute("data-app", app);
    el.setAttribute("allowtransparency", "true");
    var rec = { el: el, ready: false, queue: [] };

    function flush() {
      if (rec.ready) return;
      rec.ready = true;
      if (poll) {
        clearInterval(poll);
        poll = null;
      }
      var q = rec.queue;
      rec.queue = [];
      for (var i = 0; i < q.length; i++) {
        try {
          el.contentWindow.postMessage(q[i], "*");
        } catch (err) {
          /* ignore */
        }
      }
      // Si l'app vient de prendre le focus mais que l'iframe n'etait pas encore
      // prete, on (re)donne le focus clavier maintenant qu'elle l'est.
      if (activeFocus === app) focusFrame(rec);
    }

    // 'load' attend toutes les ressources (y compris CDN lents). On flush aussi
    // des que le DOM de l'iframe est interactif : a ce stade les scripts de fin
    // de body (ex: app.js du lobby) ont tourne et leurs listeners 'message' sont
    // enregistres. iframe meme-origine (nui://sunlife_ui) -> contentDocument lisible.
    var pollTries = 0;
    var slowed = false;
    var poll = null;

    function checkReady() {
      pollTries++;
      var doc = null;
      try {
        doc = el.contentDocument;
      } catch (err) {
        /* cross-origin improbable */
      }
      if (doc && (doc.readyState === "interactive" || doc.readyState === "complete")) {
        flush();
      } else if (!slowed && pollTries > 400) {
        // Apres ~12s on ralentit le poll (30ms -> 1s), mais on ne l'ABANDONNE
        // jamais. Avant, on comptait uniquement sur l'evenement 'load' ; si
        // celui-ci ne se declenchait pas non plus (ressource externe qui pend,
        // CDN injoignable), la file de messages restait bloquee definitivement :
        // l'app ne s'affichait jamais alors que SetNuiFocus(true) etait deja
        // applique -> curseur, jeu bloque, deco/reco obligatoire.
        slowed = true;
        clearInterval(poll);
        poll = setInterval(checkReady, 1000);
      }
    }
    poll = setInterval(checkReady, 30);

    el.addEventListener("load", flush);
    el.src = src;
    getRoot().appendChild(el);
    frames[app] = rec;
    return rec;
  }

  function forward(app, payload) {
    var rec = ensure(app);
    if (!rec) return;
    if (rec.ready) {
      try {
        rec.el.contentWindow.postMessage(payload, "*");
      } catch (err) {
        /* ignore */
      }
    } else {
      rec.queue.push(payload);
    }
  }

  // Donne le focus DOM clavier a l'iframe pour que ses listeners 'keydown'
  // (fermeture via Echap/E, saisies, etc.) se declenchent. Sans ca, avec
  // SetNuiFocus(true) le clavier reste sur le document racine du routeur et
  // l'app ne recoit jamais les touches (ex: classement peche impossible a fermer).
  function focusFrame(rec) {
    try {
      if (rec.el.contentWindow) rec.el.contentWindow.focus();
    } catch (err) {
      /* ignore */
    }
  }

  function setFocus(app, on) {
    var rec = ensure(app);
    if (!rec) return;
    if (on) {
      // Invariant : une SEULE iframe peut etre active (interactive + au-dessus).
      // On retire sl-active de TOUTES les autres, pas seulement de `activeFocus`.
      // Sans ca, une iframe restee active a cause d'un etat de focus desynchronise
      // (ex: un autre menu ferme sans router son focus=false) reste transparente
      // AU-DESSUS et capture le curseur -> le menu qu'on ouvre ensuite (magasin de
      // vetements) est inaccessible : "juste le curseur, bloque, deco/reco".
      for (var other in frames) {
        if (frames.hasOwnProperty(other) && other !== app && frames[other]) {
          frames[other].el.classList.remove("sl-active");
        }
      }
      rec.el.classList.add("sl-active");
      activeFocus = app;
      // L'iframe peut venir d'etre creee : on focus tout de suite et au
      // prochain tick (apres montage/chargement) pour fiabiliser le clavier.
      focusFrame(rec);
      setTimeout(function () {
        if (activeFocus === app) focusFrame(rec);
      }, 50);
    } else {
      rec.el.classList.remove("sl-active");
      if (activeFocus === app) activeFocus = null;
    }
  }

  window.addEventListener("message", function (e) {
    var data = e.data;
    if (!data || typeof data !== "object") return;
    if (data._slrouter) {
      setFocus(data._slapp, !!data.focus);
      return;
    }
    if (data._slapp) {
      forward(data._slapp, data._slpayload);
      return;
    }
  });

  // Relais clavier : si une touche arrive sur le document racine (le focus n'a
  // pas ete redirige vers l'iframe), on la reemet dans l'iframe active pour que
  // ses handlers 'keydown'/'keyup' (Echap, E, Entree...) se declenchent.
  function relayKey(type, e) {
    if (!activeFocus) return;
    var rec = frames[activeFocus];
    if (!rec || !rec.el.contentDocument) return;
    try {
      var evt = new KeyboardEvent(type, {
        key: e.key,
        code: e.code,
        keyCode: e.keyCode,
        which: e.which,
        location: e.location,
        ctrlKey: e.ctrlKey,
        shiftKey: e.shiftKey,
        altKey: e.altKey,
        metaKey: e.metaKey,
        repeat: e.repeat,
        bubbles: true,
        cancelable: true
      });
      rec.el.contentDocument.dispatchEvent(evt);
    } catch (err) {
      /* ignore */
    }
  }
  document.addEventListener("keydown", function (e) {
    relayKey("keydown", e);
  });
  document.addEventListener("keyup", function (e) {
    relayKey("keyup", e);
  });

  // Pre-chargement des apps persistantes : leur iframe est creee immediatement
  // pour qu'elle soit prete bien avant la 1ere interaction (cf. gunfight).
  function preloadEager() {
    for (var i = 0; i < EAGER.length; i++) {
      ensure(EAGER[i]);
    }
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", preloadEager);
  } else {
    preloadEager();
  }
})();
