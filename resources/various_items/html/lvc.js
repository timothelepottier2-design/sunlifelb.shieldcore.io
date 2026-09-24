/* LVC : NUI minimale (panneau de contrôle sirènes + audio).
   Pas de polling, juste des événements postMessage venant du Lua. */

const els = {
    panel:  document.getElementById('lvcPanel'),
    switch: document.getElementById('lvc-switch'),
    siren:  document.getElementById('lvc-siren'),
    horn:   document.getElementById('lvc-horn'),
    lock:   document.getElementById('lvc-lock'),
    radars:     document.getElementById('lvc-radars'),
    radarFront: document.getElementById('lvc-radar-front'),
    radarRear:  document.getElementById('lvc-radar-rear'),
    frontSpeed: document.getElementById('lvc-radar-front-speed'),
    frontPlate: document.getElementById('lvc-radar-front-plate'),
    rearSpeed:  document.getElementById('lvc-radar-rear-speed'),
    rearPlate:  document.getElementById('lvc-radar-rear-plate'),
};

function applyRadar(box, speedEl, plateEl, r) {
    if (!box) return;
    const has = !!(r && r.has === true);
    if (has) box.classList.remove('idle');
    else     box.classList.add('idle');
    /* Vitesse bornee a 3 chiffres (afficheur 7 segments) ; vide = segments fantomes seuls */
    if (speedEl) speedEl.textContent = has ? String(Math.min(999, Math.max(0, Math.round(r.speed)))) : '';
    if (plateEl) plateEl.textContent = has ? ((r.plate && r.plate.length) ? r.plate : 'SANS PLAQUE') : 'PLAQUE';
}

let scale = 0.72;
let audioPlayer = null;

function setOn(el, on) {
    if (!el) return;
    if (on) el.classList.add('on');
    else    el.classList.remove('on');
}

function applyScale() {
    if (els.panel) els.panel.style.transform = 'scale(' + scale + ')';
}

function playSound(file, volume) {
    if (audioPlayer) { try { audioPlayer.pause(); } catch (e) {} }
    audioPlayer = new Audio('sounds/' + file + '.ogg');
    audioPlayer.volume = volume;
    const p = audioPlayer.play();
    if (p === undefined) {
        audioPlayer = null;
    } else {
        p.catch(() => { audioPlayer = null; });
    }
}

window.addEventListener('message', function (event) {
    const data = event.data || {};

    if (data._type === 'audio') {
        playSound(data.file, data.volume);
        return;
    }

    if (data._type === 'hud:setItemState') {
        const item  = data.item;
        const state = data.state;
        switch (item) {
            case 'hud':
                if (state) els.panel.classList.remove('hidden');
                else       els.panel.classList.add('hidden');
                break;
            case 'switch': setOn(els.switch, state === true); break;
            case 'siren':  setOn(els.siren,  state === true); break;
            case 'horn':   setOn(els.horn,   state === true); break;
            case 'lock':   setOn(els.lock,   state === true); break;
        }
        return;
    }

    if (data._type === 'hud:setHudScale') {
        scale = data.scale || 0.72;
        applyScale();
        return;
    }

    /* ---------- Radars avant / arriere ---------- */
    if (data._type === 'radar:update') {
        if (!els.radars) return;
        applyRadar(els.radarFront, els.frontSpeed, els.frontPlate, data.front);
        applyRadar(els.radarRear,  els.rearSpeed,  els.rearPlate,  data.rear);
        if (data.locked === true) els.radars.classList.add('locked');
        else                      els.radars.classList.remove('locked');
        return;
    }
});

applyScale();
