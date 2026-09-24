/* =========================================================================
   Zone AFK — logique de l'overlay.

   Le serveur est la seule autorité sur les gains : il envoie un snapshot à
   l'entrée puis à chaque versement (une fois par cycle de 10 min). Entre deux
   snapshots, ce script se contente de faire descendre les compteurs
   localement — aucun trafic réseau à la seconde.
   ========================================================================= */
(function () {
    'use strict';

    var root = null;
    var els = {};

    // Etat courant, réécrit à chaque snapshot serveur.
    var state = {
        visible: false,
        money: 0,
        coins: 0,
        afkcoins: 0,
        moneyPerCycle: 10000,
        moneyEveryMin: 10,
        coinsEveryMin: 10,
        afkPerCycle: 10,
        elapsed: 0,        // secondes depuis l'entrée en zone
        nextMoney: 600,    // secondes avant le prochain versement d'argent
        nextCoin: 600      // secondes avant Suncoin + AFK Coins (même cycle)
    };

    // Le bouton "son" a été retiré : il n'y a aucune musique en zone AFK, il
    // ne pilotait qu'un bref effet sonore de récompense.
    var prefs = {
        dim: false
    };

    var ticker = null;
    var leaveWatchdog = null;

    // Défilement à 2 crans : 0 = gains, 1 = classement.
    var PAGE_COUNT = 2;
    var page = 0;
    var wheelLock = false;
    var dragging = false;

    /* --------------------------------------------------------------------
       Formatage
       -------------------------------------------------------------------- */

    // Espace insécable fine comme séparateur de milliers (rendu du mockup).
    function groupDigits(n) {
        return String(Math.max(0, Math.floor(n))).replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    function clock(seconds) {
        var s = Math.max(0, Math.floor(seconds));
        var m = Math.floor(s / 60);
        var r = s % 60;
        return (m < 10 ? '0' : '') + m + ':' + (r < 10 ? '0' : '') + r;
    }

    // Au-delà d'une heure, MM:SS ne suffit plus pour "En AFK depuis".
    function elapsedClock(seconds) {
        var s = Math.max(0, Math.floor(seconds));
        var h = Math.floor(s / 3600);
        if (h > 0) {
            var m = Math.floor((s % 3600) / 60);
            var r = s % 60;
            return h + ':' + (m < 10 ? '0' : '') + m + ':' + (r < 10 ? '0' : '') + r;
        }
        return clock(s);
    }

    /* --------------------------------------------------------------------
       Rendu
       -------------------------------------------------------------------- */

    function render() {
        els.money.textContent = groupDigits(state.money) + ' $';
        els.coins.textContent = groupDigits(state.coins);
        els.afk.textContent = groupDigits(state.afkcoins);
        els.elapsed.textContent = elapsedClock(state.elapsed);

        els.moneyNext.textContent = clock(state.nextMoney);
        els.coinNext.textContent = clock(state.nextCoin);
        // Suncoins et AFK Coins tombent sur le MÊME cycle serveur : un seul
        // compte à rebours, affiché sur les deux cartes.
        els.afkNext.textContent = clock(state.nextCoin);

        // Lu depuis le snapshot, plus codé en dur à 60 : la durée du cycle
        // d'argent est une constante serveur, la barre doit la suivre.
        var moneyCycle = state.moneyEveryMin * 60;
        var coinCycle = state.coinsEveryMin * 60;

        // La barre se remplit à mesure que le compteur descend.
        els.moneyBar.style.width = pct(moneyCycle - state.nextMoney, moneyCycle);
        els.coinBar.style.width = pct(coinCycle - state.nextCoin, coinCycle);
        els.afkBar.style.width = pct(coinCycle - state.nextCoin, coinCycle);

        els.moneyRate.textContent = groupDigits(state.moneyPerCycle) + ' $ / ' + state.moneyEveryMin + ' min';
        els.coinRate.textContent = '1 Suncoin / ' + state.coinsEveryMin + ' min';
        els.afkRate.textContent = state.afkPerCycle + ' / ' + state.coinsEveryMin + ' min';

        // Argent et coins sont sur le même cycle aujourd'hui (10 min), mais ce
        // sont deux constantes serveur distinctes : on ne fusionne la phrase
        // que si elles coïncident réellement.
        var money = '<b>' + groupDigits(state.moneyPerCycle) + ' $</b>';
        var rest = '<b>1 Suncoin</b> et <b>' + state.afkPerCycle + ' AFK Coins</b> toutes les ' +
            state.coinsEveryMin + ' minutes';

        els.footer.innerHTML = (state.moneyEveryMin === state.coinsEveryMin)
            ? 'Tu gagnes ' + money + ', ' + rest + ' tant que tu restes ici.'
            : 'Tu gagnes ' + money + ' toutes les ' + state.moneyEveryMin + ' minutes, ' +
              rest + ' tant que tu restes ici.';
    }

    /* --------------------------------------------------------------------
       Défilement 2 crans
       -------------------------------------------------------------------- */

    function goToPage(n) {
        n = Math.max(0, Math.min(PAGE_COUNT - 1, n));
        if (n === page) return;
        page = n;
        renderScroll();

        // Le classement n'est demandé qu'à la première ouverture de sa page :
        // inutile d'interroger le serveur pour une page que le joueur ne
        // regardera peut-être jamais.
        if (page === 1) post('afkRequestBoard');
    }

    // Position purement visuelle du logo sur le rail, 0 = haut, 1 = bas.
    function setThumbRatio(ratio) {
        els.scrollFill.style.height = (ratio * 100) + '%';
        els.scrollThumb.style.top = (ratio * 100) + '%';
    }

    function renderScroll() {
        var ratio = PAGE_COUNT > 1 ? (page / (PAGE_COUNT - 1)) : 0;

        els.pages.style.transform = 'translateY(' + (-page * 100) + '%)';

        // Pendant un glisser, le logo suit la souris : renderScroll ne doit
        // pas le repositionner, sinon il saute en arriere a chaque bascule.
        if (!dragging) setThumbRatio(ratio);

        for (var i = 0; i < els.notches.length; i++) {
            els.notches[i].classList.toggle('is-active', i === page);
        }
    }

    // Ratio 0..1 correspondant a la position verticale du pointeur sur le rail.
    function ratioFromPointer(clientY) {
        var rect = els.scrollTrack.getBoundingClientRect();
        if (!rect.height) return 0;
        var r = (clientY - rect.top) / rect.height;
        return Math.max(0, Math.min(1, r));
    }

    function startDrag(e) {
        if (!state.visible) return;
        e.preventDefault();
        dragging = true;
        els.scroll.classList.add('is-dragging');
        setThumbRatio(ratioFromPointer(e.clientY));
    }

    function moveDrag(e) {
        if (!dragging) return;
        var ratio = ratioFromPointer(e.clientY);
        setThumbRatio(ratio);

        // Bascule des que le logo franchit la moitie du rail.
        goToPage(ratio >= 0.5 ? 1 : 0);
    }

    function endDrag() {
        if (!dragging) return;
        dragging = false;
        els.scroll.classList.remove('is-dragging');
        // Le logo se cale sur le cran de la page retenue.
        renderScroll();
    }

    /* --------------------------------------------------------------------
       Classement
       -------------------------------------------------------------------- */

    function renderBoard(rows, myLicense) {
        var host = els.board;

        if (!rows || rows.length === 0) {
            host.innerHTML = '<div class="afk-board-empty">Aucun joueur classé pour le moment.</div>';
            return;
        }

        var html = '';
        for (var i = 0; i < rows.length; i++) {
            var r = rows[i] || {};
            var rank = r.rank || (i + 1);

            var cls = 'afk-board-row';
            if (rank <= 3) cls += ' afk-board-row--' + rank;
            if (myLicense && r.license === myLicense) cls += ' afk-board-row--me';

            html += '<div class="' + cls + '">'
                  +   '<span class="afk-board-rank">#' + rank + '</span>'
                  +   '<span class="afk-board-name">' + escapeHtml(r.name || 'Inconnu') + '</span>'
                  +   '<span class="afk-board-points">' + groupDigits(r.points || 0)
                  +     '<small>AFK Coins</small></span>'
                  + '</div>';
        }

        host.innerHTML = html;
    }

    // Les noms viennent de la base (choisis par les joueurs) : jamais injectés
    // tels quels dans le DOM.
    function escapeHtml(s) {
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function pct(done, total) {
        if (!total || total <= 0) return '0%';
        var v = (done / total) * 100;
        if (v < 0) v = 0;
        if (v > 100) v = 100;
        return v.toFixed(1) + '%';
    }

    /* --------------------------------------------------------------------
       Horloge locale
       -------------------------------------------------------------------- */

    function tick() {
        state.elapsed += 1;

        // On plancher à 0 sans reboucler : c'est le snapshot serveur qui fait
        // foi pour le redémarrage d'un cycle. Si le versement tarde (lag,
        // tick serveur chargé), on affiche 00:00 plutôt qu'un compteur qui
        // repart et se désynchronise du vrai versement.
        if (state.nextMoney > 0) state.nextMoney -= 1;
        if (state.nextCoin > 0) state.nextCoin -= 1;

        render();
    }

    function startTicker() {
        stopTicker();
        ticker = setInterval(tick, 1000);
    }

    function stopTicker() {
        if (ticker !== null) {
            clearInterval(ticker);
            ticker = null;
        }
    }

    /* --------------------------------------------------------------------
       Communication Lua
       -------------------------------------------------------------------- */

    function post(name, payload) {
        try {
            fetch('https://' + GetParentResourceName() + '/' + name, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify(payload || {})
            }).catch(function () { /* NUI fermée : sans conséquence */ });
        } catch (e) { /* idem */ }
    }

    function GetParentResourceName() {
        return (typeof window.GetParentResourceName === 'function')
            ? window.GetParentResourceName()
            : 'sunlife';
    }

    function show(data) {
        applySnapshot(data);
        state.visible = true;
        root.classList.add('afk-visible');
        // Toujours rouvrir sur la page des gains.
        page = 0;
        renderScroll();
        startTicker();
        render();
    }

    function hide() {
        state.visible = false;
        root.classList.remove('afk-visible');
        stopTicker();
        // Fermeture en plein glisser : sans ca `dragging` resterait vrai et
        // renderScroll refuserait de repositionner le logo a la reouverture.
        endDrag();

        if (leaveWatchdog !== null) {
            clearTimeout(leaveWatchdog);
            leaveWatchdog = null;
        }
    }

    // Demande de sortie.
    //
    // On NE MASQUE PAS l'overlay ici : il sert de voile pendant que le serveur
    // téléporte le joueur hors de la zone. C'est le Lua qui enverra 'close'
    // une fois arrivé à destination. Le focus, lui, est rendu tout de suite
    // côté Lua, donc le joueur n'est jamais bloqué.
    function requestLeave() {
        if (!state.visible) return;

        post('afkLeave');

        // Garde-fou si le message 'close' n'arrive jamais (callback NUI perdu,
        // ressource redémarrée) : on ne laisse pas le joueur derrière un écran
        // opaque. Volontairement plus long que le garde-fou Lua (6 s), qui
        // doit avoir eu sa chance en premier.
        if (leaveWatchdog !== null) clearTimeout(leaveWatchdog);
        leaveWatchdog = setTimeout(function () {
            leaveWatchdog = null;
            hide();
        }, 9000);
    }

    function applySnapshot(data) {
        if (!data) return;
        if (typeof data.money === 'number') state.money = data.money;
        if (typeof data.coins === 'number') state.coins = data.coins;
        if (typeof data.afkcoins === 'number') state.afkcoins = data.afkcoins;
        if (typeof data.elapsed === 'number') state.elapsed = data.elapsed;
        if (typeof data.nextMoney === 'number') state.nextMoney = data.nextMoney;
        if (typeof data.nextCoin === 'number') state.nextCoin = data.nextCoin;
        if (typeof data.moneyPerCycle === 'number') state.moneyPerCycle = data.moneyPerCycle;
        if (typeof data.moneyEveryMin === 'number') state.moneyEveryMin = data.moneyEveryMin;
        if (typeof data.coinsEveryMin === 'number') state.coinsEveryMin = data.coinsEveryMin;
        if (typeof data.afkPerCycle === 'number') state.afkPerCycle = data.afkPerCycle;
    }

    /* --------------------------------------------------------------------
       Préférences (persistées entre deux sessions AFK)
       -------------------------------------------------------------------- */

    function loadPrefs() {
        try {
            var raw = window.localStorage.getItem('sl_afk_prefs');
            if (raw) {
                var p = JSON.parse(raw);
                if (typeof p.dim === 'boolean') prefs.dim = p.dim;
            }
        } catch (e) { /* localStorage indisponible : on garde les défauts */ }
    }

    function savePrefs() {
        try {
            window.localStorage.setItem('sl_afk_prefs', JSON.stringify(prefs));
        } catch (e) { /* idem */ }
    }

    function applyPrefs() {
        root.classList.toggle('afk-dim', prefs.dim);
        els.btnDim.classList.toggle('afk-off', prefs.dim);
        els.btnDim.title = prefs.dim ? 'Luminosité normale' : 'Réduire la luminosité';
    }

    /* --------------------------------------------------------------------
       Décor : champ d'étoiles statique
       -------------------------------------------------------------------- */

    function buildStars() {
        var host = els.stars;
        var count = 90;
        var frag = document.createDocumentFragment();

        for (var i = 0; i < count; i++) {
            var s = document.createElement('span');
            s.className = 'afk-star';
            var size = (Math.random() * 1.6 + 0.6).toFixed(2);
            s.style.width = size + 'px';
            s.style.height = size + 'px';
            s.style.left = (Math.random() * 100).toFixed(2) + '%';
            s.style.top = (Math.random() * 100).toFixed(2) + '%';
            s.style.opacity = (Math.random() * 0.5 + 0.15).toFixed(2);
            frag.appendChild(s);
        }

        host.appendChild(frag);
    }

    /* --------------------------------------------------------------------
       Init
       -------------------------------------------------------------------- */

    function init() {
        root = document.getElementById('afk-root');
        if (!root) return;

        els = {
            stars: document.getElementById('afk-stars'),
            elapsed: document.getElementById('afk-elapsed-value'),
            money: document.getElementById('afk-money-value'),
            coins: document.getElementById('afk-coins-value'),
            afk: document.getElementById('afk-afk-value'),
            moneyNext: document.getElementById('afk-money-next'),
            coinNext: document.getElementById('afk-coins-next'),
            afkNext: document.getElementById('afk-afk-next'),
            moneyBar: document.getElementById('afk-money-bar'),
            coinBar: document.getElementById('afk-coins-bar'),
            afkBar: document.getElementById('afk-afk-bar'),
            moneyRate: document.getElementById('afk-money-rate'),
            coinRate: document.getElementById('afk-coins-rate'),
            afkRate: document.getElementById('afk-afk-rate'),
            footer: document.getElementById('afk-footer'),
            btnDim: document.getElementById('afk-btn-dim'),
            btnLeave: document.getElementById('afk-btn-leave'),
            pages: document.getElementById('afk-pages'),
            scroll: document.getElementById('afk-scroll'),
            scrollTrack: document.getElementById('afk-scroll-track'),
            scrollFill: document.getElementById('afk-scroll-fill'),
            scrollThumb: document.getElementById('afk-scroll-thumb'),
            notches: document.querySelectorAll('.afk-scroll-notch'),
            board: document.getElementById('afk-board')
        };

        buildStars();
        loadPrefs();
        applyPrefs();
        renderScroll();
        render();

        // Navigation entre les deux crans : molette, clic sur un cran, ou
        // flèches haut/bas.
        (function bindScroll() {
            for (var i = 0; i < els.notches.length; i++) {
                (function (idx) {
                    els.notches[idx].addEventListener('click', function () {
                        goToPage(idx);
                    });
                })(i);
            }

            root.addEventListener('wheel', function (e) {
                if (!state.visible) return;
                // Verrou le temps de la transition : une molette libre
                // enchaînerait les deux pages sur un seul geste.
                if (wheelLock) return;
                wheelLock = true;
                setTimeout(function () { wheelLock = false; }, 520);

                goToPage(page + (e.deltaY > 0 ? 1 : -1));
            }, { passive: true });

            document.addEventListener('keydown', function (e) {
                if (!state.visible) return;
                if (e.key === 'ArrowDown' || e.keyCode === 40) goToPage(page + 1);
                else if (e.key === 'ArrowUp' || e.keyCode === 38) goToPage(page - 1);
            });

            // Glisser-deposer du logo. Les listeners de deplacement et de
            // relachement sont sur `document` et pas sur le logo : sans ca, une
            // souris qui sort du rail pendant le geste laisse le curseur
            // accroche et le glisser ne se termine jamais.
            els.scrollThumb.addEventListener('mousedown', startDrag);
            els.scrollTrack.addEventListener('mousedown', startDrag);
            document.addEventListener('mousemove', moveDrag);
            document.addEventListener('mouseup', endDrag);
            window.addEventListener('blur', endDrag);
        })();

        els.btnLeave.addEventListener('click', requestLeave);

        els.btnDim.addEventListener('click', function () {
            prefs.dim = !prefs.dim;
            savePrefs();
            applyPrefs();
        });

        // Filet de sécurité : avec le focus NUI, le jeu ne reçoit plus les
        // touches. Si l'interface se retrouvait dans un état inattendu, Échap
        // doit toujours pouvoir rendre la main au joueur.
        document.addEventListener('keyup', function (e) {
            if (!state.visible) return;
            if (e.key === 'Escape' || e.keyCode === 27) {
                requestLeave();
            }
        });

        window.addEventListener('message', function (event) {
            var data = event.data || {};
            if (data.app !== 'afk') return;

            if (data.action === 'open') {
                show(data.payload);
            } else if (data.action === 'update') {
                applySnapshot(data.payload);
                render();
            } else if (data.action === 'close') {
                hide();
            } else if (data.action === 'board') {
                renderBoard(data.rows, data.me);
            }
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
