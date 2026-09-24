(function () {
    const ui = document.getElementById('mecano-ui');
    const vehicleNameEl = document.getElementById('vehicle-name');
    const plateEl = document.getElementById('plate');
    const breadcrumbEl = document.getElementById('breadcrumb');
    const listEl = document.getElementById('list');
    const btnClose = document.getElementById('btn-close');
    const notificationsEl = document.getElementById('notifications');

    let currentPath = '';
    let pathHistory = [];
    const NOTIF_DURATION = 4500;

    /* Petit son de clic (Web Audio API) */
    let clickAudioCtx = null;
    function playClickSound() {
        try {
            if (!clickAudioCtx) clickAudioCtx = new (window.AudioContext || window.webkitAudioContext)();
            if (clickAudioCtx.state === 'suspended') clickAudioCtx.resume();
            const osc = clickAudioCtx.createOscillator();
            const gain = clickAudioCtx.createGain();
            osc.connect(gain);
            gain.connect(clickAudioCtx.destination);
            osc.frequency.value = 800;
            osc.type = 'sine';
            gain.gain.setValueAtTime(0.12, clickAudioCtx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, clickAudioCtx.currentTime + 0.06);
            osc.start(clickAudioCtx.currentTime);
            osc.stop(clickAudioCtx.currentTime + 0.06);
        } catch (e) {}
    }

    /* Icônes SVG pour les catégories (style stroke, cohérent avec le clotheshop) */
    const categoryIcons = {
        upgrades: '<svg viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>',
        cosmetics: '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'upgrades.modEngine': '<svg viewBox="0 0 24 24"><path d="M6 6h12v4l-2 2v2l4 2v4h-2v-2h-4v-4l-4-2V8L6 6z"/><path d="M4 10v6h2v-4h2v4h2v-6H4z"/></svg>',
        'upgrades.modBrakes': '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 2v4M12 18v4M2 12h4M18 12h4"/></svg>',
        'upgrades.modTransmission': '<svg viewBox="0 0 24 24"><path d="M12 4v16M4 8h16M6 12h12M8 6v12M16 6v12"/></svg>',
        'upgrades.modSuspension': '<svg viewBox="0 0 24 24"><path d="M5 14l7-7 7 7"/><path d="M12 10v10"/></svg>',
        'upgrades.modTurbo': '<svg viewBox="0 0 24 24"><path d="M4 4h16v6l-4 4v2l6 2v2H6l-2-6v-2l-4-4V4z"/></svg>',
        'cosmetics.windowTint': '<svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="1"/><path d="M7 9h10"/></svg>',
        'cosmetics.modHorns': '<svg viewBox="0 0 24 24"><path d="M6 8v8h2l4 4 2-4h4V8h-2L12 4 10 8H6z"/></svg>',
        'cosmetics.modXenon': '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="5"/><path d="M12 2v2M12 20v2M4 12h2M18 12h2"/></svg>',
        'cosmetics.neonEnabled': '<svg viewBox="0 0 24 24"><path d="M5 12h14M12 5v14"/></svg>',
        'cosmetics.resprays': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.resprays.color1': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.resprays.color2': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.resprays.pearlescentColor': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.resprays.interiorColour': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.resprays.dashboardColour': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.bodyparts': '<svg viewBox="0 0 24 24"><path d="M5 17h14v2H5z"/><path d="M12 4l-4 6h3v4h2v-4h3L12 4z"/></svg>',
        'cosmetics.wheels': '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/></svg>',
        'cosmetics.wheels.types': '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3"/></svg>',
        'cosmetics.wheels.wheelColor': '<svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0L12 2.69z"/></svg>',
        'cosmetics.wheels.tyreSmokeColor': '<svg viewBox="0 0 24 24"><path d="M5 12h14M12 5v14"/></svg>',
        'cosmetics.bennysc': '<svg viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>'
    };

    function getCategoryIcon(id) {
        if (categoryIcons[id]) return categoryIcons[id];
        if (id && id.indexOf('cosmetics.bodyparts.') === 0) return categoryIcons['cosmetics.bodyparts'];
        if (id && id.indexOf('cosmetics.bennysc.') === 0) return categoryIcons['cosmetics.bennysc'];
        return categoryIcons.upgrades;
    }

    /* Traductions FR pour le breadcrumb (path ID -> libellé) */
    const pathLabelsFr = {
        upgrades: 'Performances',
        cosmetics: 'Cosmétiques',
        modEngine: 'Moteur',
        modBrakes: 'Freinage',
        modTransmission: 'Transmission',
        modSuspension: 'Suspension',
        modTurbo: 'Turbo',
        windowTint: 'Teinte vitres',
        modHorns: 'Klaxons',
        modXenon: 'Xenon',
        neonEnabled: 'Néons',
        resprays: 'Peinture',
        bodyparts: 'Carrosserie',
        wheels: 'Roues',
        bennysc: "Benny's",
        color1: 'Couleur principale',
        color2: 'Couleur secondaire',
        pearlescentColor: 'Nacré',
        interiorColour: 'Intérieur',
        dashboardColour: 'Tableau de bord',
        types: 'Type de roues',
        wheelColor: 'Couleur des roues',
        tyreSmokeColor: 'Fumée de pneu',
        sport: 'Sport',
        muscle: 'Muscle',
        lowrider: 'Lowrider',
        suv: 'SUV',
        allterrain: 'Tout terrain',
        tuning: 'Tuning',
        motorcycle: 'Moto',
        highend: 'Highend',
        bennys: "Benny's",
        bespoke: 'Sur mesure',
        street: 'Street',
        modSpoilers: 'Ailerons',
        modFrontBumper: 'Pare-chocs avant',
        modRearBumper: 'Pare-chocs arrière',
        modSideSkirt: 'Bas de caisse',
        modExhaust: 'Échappement',
        modFrame: 'Châssis',
        modGrille: 'Calandre',
        modHood: 'Capot',
        modFender: 'Aile avant',
        modRightFender: 'Aile arrière',
        modRoof: 'Toit',
        modPlateHolder: 'Support plaque',
        modVanityPlate: 'Plaque personnalisée',
        modTrimA: 'Habillage A',
        modTrimB: 'Habillage B',
        modOrnaments: 'Ornements',
        modDashboard: 'Tableau de bord',
        modDial: 'Compteur',
        modDoorSpeaker: 'Haut-parleurs portières',
        modSeats: 'Sièges',
        modSteeringWheel: 'Volant',
        modShifterLeavers: 'Levier de vitesses',
        modAPlate: 'Plaque A',
        modSpeakers: 'Enceintes',
        modTrunk: 'Coffre',
        modHydrolic: 'Hydraulique',
        modEngineBlock: 'Bloc moteur',
        modAirFilter: 'Filtre à air',
        modStruts: 'Amortisseurs',
        modArchCover: 'Couvre-arc',
        modAerials: 'Antennes',
        modTank: 'Réservoir',
        modWindows: 'Vitres',
        modLivery: 'Livrée',
    };

    function getPathLabelFr(segment) {
        return pathLabelsFr[segment] || (segment.charAt(0).toUpperCase() + segment.slice(1).replace(/([A-Z])/g, ' $1').trim());
    }

    function formatPrice(value) {
        if (value === 0 || value === '0' || value === 'GRATUIT') return 'GRATUIT';
        const n = typeof value === 'number' ? Math.floor(value) : parseInt(value, 10);
        if (isNaN(n)) return String(value);
        return n.toLocaleString('fr-FR') + ' $';
    }

    function buildBreadcrumb() {
        const parts = currentPath ? currentPath.split('.') : [];
        breadcrumbEl.innerHTML = '';
        const rootBtn = document.createElement('button');
        rootBtn.type = 'button';
        rootBtn.className = 'breadcrumb-item root';
        rootBtn.dataset.path = '';
        rootBtn.textContent = 'Garage';
        rootBtn.addEventListener('click', () => { playClickSound(); setPath(''); });
        breadcrumbEl.appendChild(rootBtn);
        parts.forEach((p, i) => {
            const sep = document.createElement('span');
            sep.className = 'breadcrumb-sep';
            sep.textContent = ' / ';
            breadcrumbEl.appendChild(sep);
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'breadcrumb-item' + (i === parts.length - 1 ? ' current' : '');
            btn.dataset.path = parts.slice(0, i + 1).join('.');
            btn.textContent = getPathLabelFr(p);
            btn.addEventListener('click', () => { playClickSound(); setPath(btn.dataset.path); });
            breadcrumbEl.appendChild(btn);
        });
    }

    function setPath(path) {
        currentPath = path;
        pathHistory = path ? path.split('.') : [];
        buildBreadcrumb();
        fetchContent(path);
    }

    function fetchContent(path) {
        fetch(`https://sJobs/mechanics/getContent`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ path: path || '' })
        }).then(resp => resp.json()).then(data => {
            render(data);
        }).catch(() => {
            listEl.innerHTML = '<li class="list-item option"><span class="label">Erreur chargement</span></li>';
        });
    }

    function render(data) {
        listEl.innerHTML = '';
        if (!data) {
            listEl.innerHTML = '<li class="list-item option"><span class="label">Aucune option</span></li>';
            return;
        }
        const items = data.items || [];
        const actions = data.actions || [];
        if (items.length === 0 && actions.length === 0) {
            listEl.innerHTML = '<li class="list-item option"><span class="label">Aucune option</span></li>';
            return;
        }
        const isCategories = data.type === 'categories';
        items.forEach(item => {
            const li = document.createElement('li');
            li.className = 'list-item ' + (isCategories ? 'category' : 'option');
            if (isCategories) {
                const iconSvg = getCategoryIcon(item.id);
                li.innerHTML = `<span class="item-icon">${iconSvg}</span><span class="label">${escapeHtml(item.name)}</span>`;
                li.addEventListener('click', () => { playClickSound(); setPath(item.id); });
            } else {
                const priceStr = item.price !== undefined && item.price !== null ? formatPrice(item.price) : '';
                const isEquiped = item.isCurrent === true;
                li.innerHTML = `
                    <span class="label">${escapeHtml(item.label)}</span>
                    <div class="price-wrap">
                        ${isEquiped ? '<span class="badge-equiped">Équipé</span>' : ''}
                        ${!isEquiped && priceStr ? `<span class="price ${priceStr === 'GRATUIT' ? 'gratuit' : ''}">${priceStr}</span>` : ''}
                        ${!isEquiped ? `<button type="button" class="btn-apply" data-mod='${JSON.stringify(item.modData || {}).replace(/'/g, "\\'")}'>Appliquer</button>` : ''}
                    </div>
                `;
                const applyBtn = li.querySelector('.btn-apply');
                if (applyBtn && applyBtn.dataset.mod) {
                    applyBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        playClickSound();
                        try {
                            const modData = JSON.parse(applyBtn.dataset.mod.replace(/\\'/g, "'"));
                            applyMod(modData);
                        } catch (err) {
                            console.error(err);
                        }
                    });
                    li.addEventListener('mouseenter', function () {
                        try {
                            const modData = JSON.parse(applyBtn.dataset.mod.replace(/\\'/g, "'"));
                            previewMod(modData);
                        } catch (err) {}
                    });
                    li.addEventListener('mouseleave', clearPreview);
                }
            }
            listEl.appendChild(li);
        });
        if (actions.length > 0) {
            const sep = document.createElement('li');
            sep.className = 'list-item list-item-sep';
            sep.setAttribute('aria-hidden', 'true');
            listEl.appendChild(sep);
            actions.forEach(action => {
                const li = document.createElement('li');
                li.className = 'list-item list-item-action';
                li.innerHTML = `<span class="label">${escapeHtml(action.label)}</span>`;
                li.addEventListener('click', () => {
                    playClickSound();
                    executeAction(action.id);
                });
                listEl.appendChild(li);
            });
        }
    }

    function executeAction(actionId) {
        fetch(`https://sJobs/mechanics/executeAction`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: actionId })
        }).then(resp => resp.json()).then(result => {
            if (result && result.ok && result.message) {
                showNotification('success', result.message);
            }
            if (result && !result.ok && result.message) {
                showNotification('error', result.message);
            }
        }).catch(() => {});
    }

    function escapeHtml(s) {
        const div = document.createElement('div');
        div.textContent = s;
        return div.innerHTML;
    }

    function applyMod(modData) {
        fetch(`https://sJobs/mechanics/applyMod`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(modData)
        }).then(resp => resp.json()).then(result => {
            if (result && result.ok) {
                setPath(currentPath);
            }
            if (result && result.message && !result.ok) {
                showNotification('error', result.message);
            }
        }).catch(() => {});
    }

    function previewMod(modData) {
        if (!modData || !modData.modName) return;
        fetch(`https://sJobs/mechanics/previewMod`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ modName: modData.modName, modValue: modData.modValue })
        }).catch(() => {});
    }

    function clearPreview() {
        fetch(`https://sJobs/mechanics/clearPreview`, { method: 'POST', body: '{}' }).catch(() => {});
    }

    /* Notifications dédiées à l'UI (toasts) */
    const iconSuccess = '<svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>';
    const iconError = '<svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>';
    const iconInfo = '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';

    function showNotification(type, text) {
        if (!notificationsEl || !text) return;
        const typeNorm = type === 'success' || type === 'error' ? type : 'info';
        const icon = typeNorm === 'success' ? iconSuccess : typeNorm === 'error' ? iconError : iconInfo;
        const node = document.createElement('div');
        node.className = 'notification ' + typeNorm;
        node.setAttribute('role', 'alert');
        node.innerHTML = '<span class="notification-icon">' + icon + '</span><span class="notification-text">' + escapeHtml(text) + '</span>';
        notificationsEl.appendChild(node);
        const remove = () => {
            node.classList.add('hide');
            setTimeout(() => {
                if (node.parentNode) node.parentNode.removeChild(node);
            }, 260);
        };
        const t = setTimeout(remove, NOTIF_DURATION);
        node._clear = () => { clearTimeout(t); remove(); };
    }

    function closeUI() {
        ui.classList.add('hidden');
        fetch(`https://sJobs/mechanics/close`, { method: 'POST', body: '{}' });
    }

    btnClose.addEventListener('click', () => { playClickSound(); closeUI(); });

    const cartSummaryEl = document.getElementById('cart-summary');
    const btnSaveCustom = document.getElementById('btn-save-custom');

    function updateCartDisplay(total, count) {
        const t = typeof total === 'number' ? total : 0;
        const c = typeof count === 'number' ? count : 0;
        if (cartSummaryEl) {
            cartSummaryEl.textContent = 'Panier : ' + (t > 0 ? t.toLocaleString('fr-FR') + ' $' : '0 $') + ' (' + c + ' article' + (c !== 1 ? 's' : '') + ')';
        }
        if (btnSaveCustom) {
            btnSaveCustom.disabled = c === 0;
        }
    }

    if (btnSaveCustom) {
        btnSaveCustom.addEventListener('click', () => {
            playClickSound();
            if (btnSaveCustom.disabled) return;
            // On désactive juste le bouton pour empêcher le double-clic.
            // On NE TOUCHE PAS au panier visuel : tant que le serveur n'a pas
            // confirmé le paiement (via 'cartUpdated' = succès, ou 'saveFailed'
            // = échec genre "propriétaire fauché"), on garde l'état affiché.
            btnSaveCustom.disabled = true;
            fetch(`https://sJobs/mechanics/saveCustom`, { method: 'POST', body: '{}' })
                .then(r => r.json())
                .then(result => {
                    if (!result || !result.ok) {
                        // Rejet côté NUI (panier vide, contexte invalide…)
                        showNotification('error', (result && result.message) || 'Erreur lors de la sauvegarde.');
                        if (btnSaveCustom) btnSaveCustom.disabled = false;
                    }
                    // Sinon, on attend la réponse du serveur (saveCustomResult).
                })
                .catch(() => {
                    showNotification('error', 'Erreur lors de la sauvegarde.');
                    if (btnSaveCustom) btnSaveCustom.disabled = false;
                });
        });
    }

    const orbitKeys = { ArrowLeft: false, ArrowRight: false };
    function sendOrbitDirection() {
        const d = orbitKeys.ArrowRight ? 1 : (orbitKeys.ArrowLeft ? -1 : 0);
        fetch(`https://sJobs/mechanics/setOrbitDirection`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ direction: d })
        }).catch(() => {});
    }
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !ui.classList.contains('hidden')) {
            if (currentPath) {
                const parts = currentPath.split('.');
                parts.pop();
                setPath(parts.join('.'));
            } else {
                closeUI();
            }
            return;
        }
        if (!ui.classList.contains('hidden') && (e.key === 'ArrowLeft' || e.key === 'ArrowRight')) {
            if (!orbitKeys[e.key]) {
                orbitKeys[e.key] = true;
                e.preventDefault();
                sendOrbitDirection();
            }
        }
    });
    document.addEventListener('keyup', (e) => {
        if (!ui.classList.contains('hidden') && (e.key === 'ArrowLeft' || e.key === 'ArrowRight')) {
            orbitKeys[e.key] = false;
            e.preventDefault();
            sendOrbitDirection();
        }
    });

    function onWheelZoom(e) {
        if (ui.classList.contains('hidden')) return;
        if (e.target.closest('.wrap')) return;
        e.preventDefault();
        const delta = e.deltaY > 0 ? 1 : -1;
        fetch(`https://sJobs/mechanics/setOrbitZoom`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ delta: delta })
        }).catch(() => {});
    }
    document.addEventListener('wheel', onWheelZoom, { passive: false, capture: true });

    window.addEventListener('message', (event) => {
        const d = event.data;
        if (d.action === 'open') {
            vehicleNameEl.textContent = d.vehicleName || '—';
            plateEl.textContent = d.plate ? ('Plaque: ' + d.plate) : '—';
            currentPath = '';
            pathHistory = [];
            buildBreadcrumb();
            updateCartDisplay(0, 0);
            ui.classList.remove('hidden');
            fetchContent('');
        } else if (d.action === 'cartUpdated') {
            updateCartDisplay(d.total || 0, d.count || 0);
        } else if (d.action === 'close') {
            ui.classList.add('hidden');
        } else if (d.action === 'notification') {
            showNotification(d.type || 'info', d.text || d.message || '');
        } else if (d.action === 'modApplied') {
            fetchContent(currentPath);
        } else if (d.action === 'saveFailed') {
            // Échec serveur (proprio sans argent…) : on réactive le bouton
            // "Sauvegarder" pour que le mécano puisse retenter ; le panier
            // visuel et les customs en cours restent intacts.
            if (btnSaveCustom) btnSaveCustom.disabled = false;
        }
    });
})();
