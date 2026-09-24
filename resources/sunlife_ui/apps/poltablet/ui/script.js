/* ====== LSPD MDT — Script ====== */
var app = document.getElementById("app");
var frame = document.getElementById("frame");
var bootScreen = document.getElementById("bootScreen");
var mainScreen = document.getElementById("mainScreen");
var resourceName = "sunlife_ui/poltablet";
var hasCustomMugshot = false;
var pendingCreateTarget = null;
var playerGradeLevel = 0;
var sessionDeleteCount = 0;
var SESSION_DELETE_MAX = 3;
var sessionDeleteUnlimited = false; // DOJ : pas de limite par connexion (decide par le serveur)
function deleteLimitReached() { return !sessionDeleteUnlimited && sessionDeleteCount >= SESSION_DELETE_MAX; }
var defaultBackgroundColor = "#0b1120";
var currentFrameColor = "#060d1a";
var STORAGE_THEME = "SNL_PolTablet-theme";
var STORAGE_BG_NAVY_LEGACY = "SNL_PolTablet-bg-navy";

function getTheme() {
    try {
        var t = localStorage.getItem(STORAGE_THEME);
        if (t === "dark" || t === "navy" || t === "light") return t;
        if (localStorage.getItem(STORAGE_BG_NAVY_LEGACY) === "1") return "navy";
    } catch (e) {}
    return "dark";
}
function setTheme(t) {
    try { localStorage.setItem(STORAGE_THEME, t); } catch (e) {}
}

/* ====== SONS NAVIGATION (tablette réaliste) ====== */
var STORAGE_SOUND = "SNL_PolTablet-sound";
var STORAGE_SOUND_PACK = "SNL_PolTablet-sound-pack";

function getSoundEnabled() {
    try { return localStorage.getItem(STORAGE_SOUND) !== "0"; } catch (e) { return true; }
}
function setSoundEnabled(on) {
    try { localStorage.setItem(STORAGE_SOUND, on ? "1" : "0"); } catch (e) {}
}
function getSoundPack() {
    try {
        var p = localStorage.getItem(STORAGE_SOUND_PACK);
        if (p === "touch" || p === "mechanical" || p === "subtle" || p === "off") return p;
    } catch (e) {}
    return "touch";
}
function setSoundPack(p) {
    try { localStorage.setItem(STORAGE_SOUND_PACK, p); } catch (e) {}
}

var _audioCtx = null;
function getAudioContext() {
    if (_audioCtx) return _audioCtx;
    if (typeof AudioContext !== "undefined" || typeof webkitAudioContext !== "undefined") {
        _audioCtx = new (AudioContext || webkitAudioContext)();
    }
    return _audioCtx;
}

function playUiSound() {
    if (!getSoundEnabled()) return;
    var pack = getSoundPack();
    if (pack === "off") return;
    var ctx = getAudioContext();
    if (!ctx) return;
    if (ctx.state === "suspended") ctx.resume();
    var now = ctx.currentTime;
    var osc = ctx.createOscillator();
    var gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    if (pack === "touch") {
        osc.type = "sine";
        osc.frequency.setValueAtTime(1200, now);
        osc.frequency.exponentialRampToValueAtTime(800, now + 0.015);
        gain.gain.setValueAtTime(0.06, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
    } else if (pack === "mechanical") {
        osc.type = "square";
        osc.frequency.setValueAtTime(800, now);
        gain.gain.setValueAtTime(0.04, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.06);
    } else if (pack === "subtle") {
        osc.type = "sine";
        osc.frequency.setValueAtTime(1000, now);
        gain.gain.setValueAtTime(0.02, now);
        gain.gain.exponentialRampToValueAtTime(0.001, now + 0.02);
    } else return;
    osc.start(now);
    osc.stop(now + 0.05);
}

function playCameraShutterSound() {
    var ctx = getAudioContext();
    if (!ctx) return;
    if (ctx.state === "suspended") ctx.resume();
    var now = ctx.currentTime;
    var osc = ctx.createOscillator();
    var gain = ctx.createGain();
    osc.type = "sine";
    osc.frequency.setValueAtTime(1200, now);
    osc.frequency.exponentialRampToValueAtTime(800, now + 0.03);
    gain.gain.setValueAtTime(0.08, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.start(now);
    osc.stop(now + 0.05);
}

function playPanicAlarm() {
    var ctx = getAudioContext();
    if (!ctx) return;
    if (ctx.state === "suspended") ctx.resume();
    var now = ctx.currentTime;
    var osc = ctx.createOscillator();
    var gain = ctx.createGain();
    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(800, now);
    osc.frequency.setValueAtTime(1200, now + 0.15);
    osc.frequency.setValueAtTime(800, now + 0.3);
    gain.gain.setValueAtTime(0.08, now);
    gain.gain.setValueAtTime(0, now + 0.35);
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.start(now);
    osc.stop(now + 0.4);
}

function showPanicAlert(data) {
    var overlay = document.getElementById("panicOverlay");
    var agentEl = document.getElementById("panicOverlayAgent");
    var coordsEl = document.getElementById("panicOverlayCoords");
    if (!overlay) return;
    var name = data.playerName || data.name || "Agent en difficulté";
    var coords = data.coords || data.coordinates;
    var coordStr = "";
    if (coords && (coords.x != null || coords.gameX != null)) {
        var x = coords.x != null ? coords.x : coords.gameX;
        var y = coords.y != null ? coords.y : coords.gameY;
        coordStr = "Position : " + Math.round(x) + ", " + Math.round(y);
    }
    if (agentEl) agentEl.textContent = name;
    if (coordsEl) { coordsEl.textContent = coordStr; coordsEl.style.display = coordStr ? "" : "none"; }
    overlay.classList.remove("hidden");
    playPanicAlarm();
}
function hidePanicOverlay() {
    var overlay = document.getElementById("panicOverlay");
    if (overlay) overlay.classList.add("hidden");
}
var panicOverlayDismiss = document.getElementById("panicOverlayDismiss");
if (panicOverlayDismiss) panicOverlayDismiss.addEventListener("click", hidePanicOverlay);
var panicOverlayEl = document.getElementById("panicOverlay");
if (panicOverlayEl) panicOverlayEl.addEventListener("click", function (e) { if (e.target === panicOverlayEl) hidePanicOverlay(); });

/* ====== BOOT SEQUENCE ====== */
function runBootSequence(cb) {
    var bar = document.getElementById("bootProgressBar");
    if (!bar) { if (cb) cb(); return; }
    bar.style.width = "0%";
    var progress = 0;
    var duration = 1400;
    var interval = 30;
    var steps = duration / interval;
    var tick = 0;

    var timer = setInterval(function () {
        tick++;
        progress = Math.min(100, Math.round((tick / steps) * 100));
        bar.style.width = progress + "%";
        if (tick >= steps) {
            clearInterval(timer);
            bar.style.width = "100%";
            setTimeout(function () {
                if (bootScreen) bootScreen.classList.add("fade-out");
                setTimeout(function () {
                    if (bootScreen) bootScreen.classList.add("hidden");
                    if (mainScreen) mainScreen.classList.remove("hidden");
                    if (cb) cb();
                }, 200);
            }, 100);
        }
    }, interval);
}

/* ====== MAP (Leaflet) ====== */
var leafletMap = null, leafletMapOverlay = null, leafletAgentLayer = null;
var mapBounds = { minX: -4000, maxX: 4000, minY: -4000, maxY: 4000 };
var mapImageSize = { width: 2048, height: 2048 };
var mapControlPoints = [], mapYFlipped = false, mapLinear = true, mapSwapXY = false, mapCalib = null;
var pendingAgentUpdate = null;

function computeCalibration(points, imgSize) {
    if (!points || points.length < 2 || !imgSize || !imgSize.width || !imgSize.height) return null;
    var n = points.length;
    var sumX = 0, sumY = 0, sumPx = 0, sumPy = 0, sumX2 = 0, sumY2 = 0, sumXpx = 0, sumYpy = 0;
    for (var i = 0; i < n; i++) {
        var gx = points[i].gameX, gy = points[i].gameY, px = points[i].px, py = points[i].py;
        sumX += gx; sumY += gy; sumPx += px; sumPy += py;
        sumX2 += gx * gx; sumY2 += gy * gy;
        sumXpx += gx * px; sumYpy += gy * py;
    }
    var detX = n * sumX2 - sumX * sumX, detY = n * sumY2 - sumY * sumY;
    if (Math.abs(detX) < 1e-10 || Math.abs(detY) < 1e-10) return null;
    return {
        scaleX: (n * sumXpx - sumX * sumPx) / detX,
        offsetX: (sumPx - ((n * sumXpx - sumX * sumPx) / detX) * sumX) / n,
        scaleY: (n * sumYpy - sumY * sumPy) / detY,
        offsetY: (sumPy - ((n * sumYpy - sumY * sumPy) / detY) * sumY) / n,
        imgW: imgSize.width, imgH: imgSize.height
    };
}

function gameToMapLatLng(gameX, gameY, calib, bounds) {
    if (!calib || !bounds) return null;
    var px = calib.scaleX * gameX + calib.offsetX;
    var py = calib.scaleY * gameY + calib.offsetY;
    return { lat: bounds.maxY - (py / calib.imgH) * (bounds.maxY - bounds.minY), lng: bounds.minX + (px / calib.imgW) * (bounds.maxX - bounds.minX) };
}

var LbTabletCRS = null;
function getLbTabletCrs() {
    if (LbTabletCRS) return LbTabletCRS;
    if (typeof L === "undefined") return null;
    LbTabletCRS = L.extend({}, L.CRS.Simple, {
        projection: L.Projection.LonLat,
        scale: function (z) { return Math.pow(2, z); },
        zoom: function (s) { return Math.log(s) / 0.6931471805599453; },
        distance: function (a, b) { var dx = b.lng - a.lng, dy = b.lat - a.lat; return Math.sqrt(dx * dx + dy * dy); },
        transformation: new L.Transformation(0.02072, 117.3, -0.0205, 172.8),
        infinite: true
    });
    return LbTabletCRS;
}

function initLeafletMap() {
    var el = document.getElementById("leafletMap");
    if (!el || typeof L === "undefined") return;
    if (leafletMap) { leafletMap.remove(); leafletMap = null; leafletMapOverlay = null; leafletAgentLayer = null; }
    var b = mapBounds;
    var southWest = L.latLng(b.minY, b.minX);
    var northEast = L.latLng(b.maxY, b.maxX);
    var bounds = L.latLngBounds(southWest, northEast);
    leafletMap = L.map(el, {
        crs: mapLinear ? L.CRS.Simple : getLbTabletCrs(),
        center: [(b.minY + b.maxY) / 2, (b.minX + b.maxX) / 2],
        zoom: -2, minZoom: -3, maxZoom: 4,
        bounceAtZoomLimits: true, maxBoundsViscosity: 0.95, maxBounds: bounds,
        preferCanvas: false, zoomControl: false, attributionControl: false, boxZoom: false
    });
    L.control.zoom({ position: "bottomright" }).addTo(leafletMap);
    var imgUrl = "nui://sunlife_ui/apps/poltablet/ui/assets/map.png";
    leafletMapOverlay = L.imageOverlay(imgUrl, bounds, { className: "map-overlay" }).addTo(leafletMap);
    leafletMapOverlay.on("error", function () { leafletMapOverlay.setUrl("nui://sunlife_ui/apps/poltablet/ui/assets/map.svg"); });
    leafletAgentLayer = L.layerGroup().addTo(leafletMap);
    leafletMap.fitBounds(bounds, { animate: false });
    [100, 300, 600, 1200].forEach(function (ms) {
        setTimeout(function () { if (leafletMap) leafletMap.invalidateSize(); }, ms);
    });
    if (pendingAgentUpdate) {
        var p = pendingAgentUpdate;
        pendingAgentUpdate = null;
        setTimeout(function () {
            updateMapAgents(p.agents, p.bounds, p.yFlipped, p.linear, p.swapXY, p.imgSize, p.controlPoints);
        }, 50);
    }
}

function renderDashAgentsList(agents) {
    var listEl = document.getElementById("dashAgentsList");
    var countEl = document.getElementById("agentsCountLabel");
    var statEl = document.getElementById("statUnites");
    if (!listEl) return;
    listEl.innerHTML = "";
    var items = [];
    if (Array.isArray(agents)) {
        var seen = {};
        agents.forEach(function (a) {
            var src = a.source != null ? a.source : (a.id != null ? a.id : null);
            if (src != null && seen[src]) return;
            if (src != null) seen[src] = true;
            var name = a.label || a.name || ("Agent #" + (src || "?"));
            items.push({ name: name, id: src });
        });
    }
    if (countEl) countEl.textContent = items.length + " agent" + (items.length !== 1 ? "s" : "") + " en service";
    if (statEl) statEl.textContent = items.length;
    if (items.length === 0) {
        listEl.innerHTML = "<li class=\"dash-agents-empty\">Aucun agent en service</li>";
        return;
    }
    items.forEach(function (ag) {
        var li = document.createElement("li");
        li.innerHTML = "<span class=\"dash-agent-dot\"></span><span class=\"dash-agent-name\">" + escapeHtml(ag.name) + "</span>" + (ag.id ? "<span class=\"dash-agent-id\">#" + escapeHtml(String(ag.id)) + "</span>" : "");
        listEl.appendChild(li);
    });
}

function updateMapAgents(agents, bounds, yFlipped, linear, swapXY, imgSize, controlPoints) {
    if (bounds) mapBounds = bounds;
    if (yFlipped !== undefined) mapYFlipped = !!yFlipped;
    if (linear !== undefined) mapLinear = !!linear;
    if (swapXY !== undefined) mapSwapXY = !!swapXY;
    if (imgSize) mapImageSize = imgSize;
    if (controlPoints) mapControlPoints = controlPoints;
    mapCalib = computeCalibration(mapControlPoints, mapImageSize);
    renderDashAgentsList(agents);
    if (!leafletAgentLayer) {
        pendingAgentUpdate = { agents: agents, bounds: bounds, yFlipped: yFlipped, linear: linear, swapXY: swapXY, imgSize: imgSize, controlPoints: controlPoints };
        return;
    }
    leafletAgentLayer.clearLayers();
    if (!Array.isArray(agents)) return;
    var seen = {}, useCalib = !!mapCalib;
    agents.forEach(function (a) {
        var src = a.source != null ? a.source : (a.id != null ? a.id : null);
        if (src != null && seen[src]) return;
        if (src != null) seen[src] = true;
        var gameX, gameY;
        if (a.gameX != null && a.gameY != null) { gameX = a.gameX; gameY = a.gameY; }
        else if (typeof a.x === "number" && typeof a.y === "number") { gameX = a.x; gameY = a.y; }
        else return;
        var lat, lng;
        if (useCalib) { var pt = gameToMapLatLng(gameX, gameY, mapCalib, mapBounds); if (!pt) return; lat = pt.lat; lng = pt.lng; }
        else { var y = mapYFlipped ? -gameY : gameY; lat = mapSwapXY ? gameX : y; lng = mapSwapXY ? y : gameX; }
        var m = L.circleMarker(L.latLng(lat, lng), { radius: 6, fillColor: "#ef4444", color: "#ffffff", weight: 2, opacity: 1, fillOpacity: 1, className: "agent-marker" });
        var agentName = a.label || a.name || (src != null ? "Agent #" + src : null);
        var agentGrade = a.grade || a.job_grade || null;
        var tooltipHtml = "";
        if (agentName || agentGrade) {
            tooltipHtml = "<div class=\"mdt-map-tooltip\">" +
                "<span class=\"mdt-map-tooltip-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z\"/></svg></span>" +
                "<div class=\"mdt-map-tooltip-body\">" +
                "<span class=\"mdt-map-tooltip-name\">" + (agentName ? escapeHtml(agentName) : "\u2014") + "</span>" +
                (agentGrade ? "<span class=\"mdt-map-tooltip-grade\">" + escapeHtml(agentGrade) + "</span>" : "") +
                "</div></div>";
        }
        if (tooltipHtml) m.bindTooltip(tooltipHtml, { permanent: false, direction: "top", className: "mdt-agent-tooltip", offset: [0, -8] });
        m.addTo(leafletAgentLayer);
    });
}

/* ====== COLORS ====== */
function setColors(frameColor, backgroundColor) {
    if (frameColor) { frame.style.setProperty("--frame-color", frameColor); currentFrameColor = frameColor; }
    if (backgroundColor) defaultBackgroundColor = backgroundColor;
}

/* ====== DUTY ====== */
var isOnDuty = false;
var DUTY_FREE_PAGES = { dashboard: true, settings: true, photo: true };

function updateDutyButton(onDuty) {
    isOnDuty = !!onDuty;
    var btn = document.getElementById("dutyBtn");
    var lbl = document.getElementById("dutyLabel");
    if (btn) { btn.classList.toggle("duty-on", onDuty); btn.classList.toggle("duty-off", !onDuty); }
    if (lbl) lbl.textContent = onDuty ? "En service" : "Hors service";
    updateNavLock();
}

function updateNavLock() {
    document.querySelectorAll(".mdt-nav-btn").forEach(function (btn) {
        var pg = btn.dataset.page;
        if (!pg) return;
        var locked = !isOnDuty && !DUTY_FREE_PAGES[pg];
        btn.classList.toggle("nav-locked", locked);
    });
    if (!isOnDuty && currentPage && !DUTY_FREE_PAGES[currentPage]) {
        navigateTo("dashboard");
    }
}

function toggleDuty() { fetch("https://" + resourceName + "/toggleDuty", { method: "POST", body: JSON.stringify({}) }).catch(function () {}); }
var dutyBtn = document.getElementById("dutyBtn");
if (dutyBtn) dutyBtn.addEventListener("click", toggleDuty);

/* ====== PLAYER CARD ====== */
function updatePlayerCard(player) {
    var mugshotEl = document.getElementById("playerMugshot");
    var initialsEl = document.getElementById("playerInitials");
    var nameEl = document.getElementById("playerName");
    var gradeEl = document.getElementById("playerGrade");
    if (!mugshotEl || !initialsEl || !nameEl || !gradeEl) return;
    hasCustomMugshot = !!(player && player.mugshot && String(player.mugshot).trim());
    if (!player) { nameEl.textContent = "\u2014"; gradeEl.textContent = "\u2014"; initialsEl.textContent = "\u2014"; initialsEl.style.display = ""; var img = mugshotEl.querySelector("img"); if (img) img.remove(); return; }
    var first = (player.firstname || "").trim(), last = (player.lastname || "").trim();
    nameEl.textContent = formatName(first, last);
    gradeEl.textContent = player.job_grade || "\u2014";
    if (player.mugshot) {
        var img = mugshotEl.querySelector("img");
        if (!img) { img = document.createElement("img"); img.alt = ""; mugshotEl.appendChild(img); }
        img.src = player.mugshot; initialsEl.style.display = "none";
    } else {
        var img2 = mugshotEl.querySelector("img"); if (img2) img2.remove(); initialsEl.style.display = "";
        var a = (first.charAt(0) || "").toUpperCase(), b2 = (last.charAt(0) || "").toUpperCase();
        initialsEl.textContent = a && b2 ? a + b2 : (a || b2 || "\u2014");
    }
}
function setMugshotFromUrl(url) {
    var mugshotEl = document.getElementById("playerMugshot");
    var initialsEl = document.getElementById("playerInitials");
    if (!mugshotEl || !initialsEl) return;
    if (!url || !url.trim()) { var img = mugshotEl.querySelector("img"); if (img) img.remove(); initialsEl.style.display = ""; return; }
    var img2 = mugshotEl.querySelector("img");
    if (!img2) { img2 = document.createElement("img"); img2.alt = ""; mugshotEl.appendChild(img2); }
    img2.src = url; initialsEl.style.display = "none";
}

/* ====== NAVIGATION ====== */
var pages = {
    dashboard: document.getElementById("pageDashboard"),
    profiles: document.getElementById("pageProfiles"),
    vehicles: document.getElementById("pageVehicles"),
    warrants: document.getElementById("pageWarrants"),
    casiers: document.getElementById("pageCasiers"),
    rapports: document.getElementById("pageRapports"),
    photo: document.getElementById("pagePhoto"),
    settings: document.getElementById("pageSettings")
};
var currentPage = "dashboard";

function navigateTo(page) {
    if (!isOnDuty && !DUTY_FREE_PAGES[page]) {
        showToast("Vous devez prendre votre service pour accéder à cette section");
        return;
    }
    currentPage = page;
    Object.keys(pages).forEach(function (k) { if (pages[k]) pages[k].classList.toggle("hidden", k !== page); });
    document.querySelectorAll(".mdt-nav-btn").forEach(function (btn) { btn.classList.toggle("active", btn.dataset.page === page); });

    if (page === "profiles") {
        profilesShowView("results");
        profilesWantedActive = false;
        if (profilesWantedFilter) profilesWantedFilter.classList.remove("active");
        if (profilesSearchInput) { profilesSearchInput.value = ""; profilesSearchInput.focus(); }
        if (profilesResultsList) profilesResultsList.innerHTML = "";
    }
    if (page === "vehicles") {
        if (vehiclesDetailPanel) vehiclesDetailPanel.classList.add("hidden");
        if (vehiclesCreateForm) vehiclesCreateForm.classList.add("hidden");
        if (vehiclesResultsWrap) vehiclesResultsWrap.classList.remove("hidden");
        if (vehiclesSearchResultsSection) vehiclesSearchResultsSection.classList.add("hidden");
        vehiclesHideSuggestions();
        vehiclesLoadWanted();
    }
    if (page === "warrants") {
        if (warrantsCreateForm) warrantsCreateForm.classList.add("hidden");
        if (warrantDetailPanel) warrantDetailPanel.classList.add("hidden");
        if (warrantsResultsWrap) warrantsResultsWrap.classList.remove("hidden");
        warrantsLoadActive();
    }
    if (page === "casiers") {
        if (casiersCreateForm) casiersCreateForm.classList.add("hidden");
        if (casiersDetailPanel) casiersDetailPanel.classList.add("hidden");
        if (casiersResultsWrap) casiersResultsWrap.classList.remove("hidden");
        if (casiersSearchInput) casiersSearchInput.value = "";
        casiersLoadRecent();
    }
    if (page === "rapports") {
        if (rapportsCreateForm) rapportsCreateForm.classList.add("hidden");
        if (rapportsDetailPanel) rapportsDetailPanel.classList.add("hidden");
        if (rapportsResultsWrap) rapportsResultsWrap.classList.remove("hidden");
        if (rapportsSearchInput) rapportsSearchInput.value = "";
        rapportsLoadRecent();
    }
    if (page === "photo") {
        photoRenderGallery();
    }
    if (pendingCreateTarget) {
        var target = pendingCreateTarget;
        pendingCreateTarget = null;
        if (page === "warrants") { warrantsOpenCreateWithTarget(target); }
        else if (page === "casiers") { casiersOpenCreateWithTarget(target); }
        else if (page === "rapports") { rapportsOpenCreateWithTarget(target); }
    }
    if (page === "dashboard") {
        [50, 200, 500].forEach(function (ms) {
            setTimeout(function () { if (leafletMap) leafletMap.invalidateSize(); }, ms);
        });
    }
}

document.querySelectorAll(".mdt-nav-btn").forEach(function (btn) {
    btn.addEventListener("click", function () { playUiSound(); navigateTo(this.dataset.page); });
});
document.body.addEventListener("click", function (e) {
    if (e.target.closest(".mdt-nav-btn")) return;
    if (e.target.closest(".qs-filter, .alert-preset-btn, .alert-urgency-btn")) { playUiSound(); return; }
    if (e.target.closest(".mdt-btn-primary, .mdt-btn-accent, .mdt-btn-filter, .mdt-back")) playUiSound();
});

/* ====== OPEN / CLOSE ====== */
function openUI(config) {
    if (config) {
        setColors(config.frameColor, config.backgroundColor);
        applyTheme();
        applySoundSettings();
        if (config.player) {
            updatePlayerCard(config.player);
            var profileImageUrl = document.getElementById("profileImageUrl");
            if (profileImageUrl) profileImageUrl.value = config.player.mugshot || "";
        }
    }
    if (bootScreen) { bootScreen.classList.remove("hidden", "fade-out"); }
    if (mainScreen) mainScreen.classList.add("hidden");
    app.classList.remove("hidden");

    runBootSequence(function () {
        applySoundSettings();
        navigateTo("dashboard");
        requestAnimationFrame(function () {
            initLeafletMap();
            setTimeout(function () {
                fetch("https://" + resourceName + "/requestAgentPositions", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
            }, 500);
        });
    });
}

var isClosing = false;
function closeUI() {
    app.classList.add("hidden");
    var tabletDev = document.querySelector(".tablet-device");
    var bezel = document.getElementById("cameraBezel");
    if (tabletDev) tabletDev.classList.remove("camera-mode-active");
    if (bezel) bezel.classList.add("hidden");
    fetch("https://" + resourceName + "/close", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
    isClosing = false;
}
function runShutdownSequence(cb) {
    var bar = document.getElementById("bootProgressBar");
    if (!bar || !bootScreen || !mainScreen) { if (cb) cb(); return; }
    isClosing = true;
    mainScreen.classList.add("shutdown");
    mainScreen.classList.remove("hidden");
    setTimeout(function () {
        mainScreen.classList.add("hidden");
        mainScreen.classList.remove("shutdown");
        bootScreen.classList.remove("hidden", "fade-out", "shutdown-out");
        bootScreen.classList.add("shutdown-in");
        bar.style.width = "0%";
        var duration = 1200;
        var interval = 25;
        var steps = duration / interval;
        var tick = 0;
        var timer = setInterval(function () {
            tick++;
            var progress = Math.min(100, Math.round((tick / steps) * 100));
            bar.style.width = progress + "%";
            if (tick >= steps) {
                clearInterval(timer);
                bar.style.width = "100%";
                bootScreen.classList.remove("shutdown-in");
                bootScreen.classList.add("fade-out");
                setTimeout(function () {
                    bootScreen.classList.add("hidden");
                    bootScreen.classList.remove("fade-out");
                    if (cb) cb();
                }, 200);
            }
        }, interval);
    }, 350);
}
var btnCloseTablet = document.getElementById("btnCloseTablet");
if (btnCloseTablet) btnCloseTablet.addEventListener("click", function () {
    playUiSound();
    closeUI();
});
var btnPowerTablet = document.getElementById("btnPowerTablet");
if (btnPowerTablet) {
    btnPowerTablet.addEventListener("click", function () {
        if (isClosing) return;
        playUiSound();
        runShutdownSequence(closeUI);
    });
    btnPowerTablet.addEventListener("keydown", function (e) {
        if (e.key === "Enter" || e.key === " ") { e.preventDefault(); btnPowerTablet.click(); }
    });
}

/* ====== UTILITY ====== */
function escapeHtml(s) { if (s == null) return ""; var d = document.createElement("div"); d.textContent = s; return d.innerHTML; }
function capitalize(s) { if (!s) return ""; return s.charAt(0).toUpperCase() + s.slice(1).toLowerCase(); }
function formatName(first, last) { var parts = [capitalize(first || ""), capitalize(last || "")].filter(Boolean); return parts.join(" ") || "\u2014"; }
function formatDate(val) {
    if (!val) return "\u2014";
    var d;
    if (typeof val === "number") {
        d = new Date(val > 9999999999 ? val : val * 1000);
    } else {
        var s = String(val);
        var n = Number(s);
        if (!isNaN(n) && s.length >= 10) { d = new Date(n > 9999999999 ? n : n * 1000); }
        else { d = new Date(s); }
    }
    if (isNaN(d.getTime())) return String(val);
    var dd = d.getDate().toString().padStart(2, "0");
    var mm = (d.getMonth() + 1).toString().padStart(2, "0");
    var yy = d.getFullYear();
    var hh = d.getHours().toString().padStart(2, "0");
    var mi = d.getMinutes().toString().padStart(2, "0");
    return dd + "/" + mm + "/" + yy + " " + hh + ":" + mi;
}
function openLightbox(url) {
    var existing = document.getElementById("mdtLightbox");
    if (existing) existing.remove();
    var overlay = document.createElement("div");
    overlay.id = "mdtLightbox";
    overlay.className = "mdt-lightbox";
    function closeLightbox() {
        var lb = document.getElementById("mdtLightbox");
        if (lb) lb.remove();
        document.removeEventListener("keydown", onKeydown, true);
    }
    function onKeydown(e) {
        if (e.key === "Escape" || e.key === "Backspace") {
            e.preventDefault();
            e.stopImmediatePropagation();
            closeLightbox();
        }
    }
    overlay.addEventListener("click", function () { closeLightbox(); });
    var inner = document.createElement("div");
    inner.className = "mdt-lightbox-inner";
    inner.addEventListener("click", function (e) { e.stopPropagation(); });
    var closeBtn = document.createElement("button");
    closeBtn.type = "button";
    closeBtn.className = "mdt-lightbox-close";
    closeBtn.setAttribute("aria-label", "Fermer");
    closeBtn.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><line x1=\"18\" y1=\"6\" x2=\"6\" y2=\"18\"/><line x1=\"6\" y1=\"6\" x2=\"18\" y2=\"18\"/></svg>";
    closeBtn.addEventListener("click", function (e) { e.stopPropagation(); closeLightbox(); });
    var img = document.createElement("img");
    img.src = url;
    img.alt = "Evidence";
    inner.appendChild(img);
    inner.appendChild(closeBtn);
    overlay.appendChild(inner);
    document.body.appendChild(overlay);
    document.addEventListener("keydown", onKeydown, true);
}
function populateTargetResults(list, container, onSelect) {
    container.innerHTML = "";
    container.classList.toggle("hidden", list.length === 0);
    list.forEach(function (c) {
        var li = document.createElement("li");
        var btn = document.createElement("button"); btn.type = "button";
        btn.textContent = formatName(c.firstname, c.lastname) + " (" + (c.identifier || "") + ")";
        btn.addEventListener("click", function () { onSelect(c); });
        li.appendChild(btn); container.appendChild(li);
    });
}

/* ====== TOAST NOTIFICATION ====== */
function showToast(msg, duration) {
    duration = duration || 2500;
    var existing = document.getElementById("mdtToast");
    if (existing) existing.remove();
    var toast = document.createElement("div");
    toast.id = "mdtToast";
    toast.className = "mdt-toast";
    toast.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><polyline points=\"20 6 9 17 4 12\"/></svg><span>" + escapeHtml(msg) + "</span>";
    var container = document.querySelector(".main-screen") || document.body;
    container.appendChild(toast);
    requestAnimationFrame(function () { toast.classList.add("show"); });
    setTimeout(function () {
        toast.classList.remove("show");
        setTimeout(function () { if (toast.parentNode) toast.remove(); }, 300);
    }, duration);
}

/* ====== PROFILES ====== */
var profilesSearchInput = document.getElementById("profilesSearchInput");
var profilesResultsWrap = document.getElementById("profilesResultsWrap");
var profilesResultsList = document.getElementById("profilesResultsList");
var profilesDetail = document.getElementById("profilesDetail");
var profileDetailScroll = document.getElementById("profileDetailScroll");
var profilesActionForm = document.getElementById("profilesActionForm");
var profilesActionFormTitle = document.getElementById("profilesActionFormTitle");
var profilesActionFormInput = document.getElementById("profilesActionFormInput");
var profilesActionFormCancel = document.getElementById("profilesActionFormCancel");
var profilesActionFormSubmit = document.getElementById("profilesActionFormSubmit");
var profilesSectionWrap = document.getElementById("profilesSectionWrap");
var profilesSectionTitle = document.getElementById("profilesSectionTitle");
var profilesSectionContent = document.getElementById("profilesSectionContent");
var profilesRecentWrap = document.getElementById("profilesRecentWrap");
var profilesRecentList = document.getElementById("profilesRecentList");
var citizenPhotoModal = document.getElementById("citizenPhotoModal");
var citizenPhotoInput = document.getElementById("citizenPhotoInput");
var citizenPhotoCancelBtn = document.getElementById("citizenPhotoCancelBtn");
var citizenPhotoSaveBtn = document.getElementById("citizenPhotoSaveBtn");
var profilesWantedFilter = document.getElementById("profilesWantedFilter");
var profilesWantedActive = false;
var knownRedList = {};
var currentCitizenProfile = null;
var profilesSearchDebounce = null;
var profilesPendingAction = null;
var PROFILE_RECENT_KEY = "SNL_PolTablet-recent-profiles";
var PROFILE_RECENT_MAX = 10;

function updateKnownRedList(list) {
    if (!list || !list.length) return;
    list.forEach(function (c) {
        if (c.identifier) knownRedList[c.identifier] = !!c.onRedList;
    });
    syncRecentRedList();
}
function syncRecentRedList() {
    var arr = getProfileRecent();
    var changed = false;
    arr.forEach(function (c) {
        if (c.identifier && knownRedList[c.identifier] !== undefined) {
            var newVal = knownRedList[c.identifier];
            if (c.onRedList !== newVal) { c.onRedList = newVal; changed = true; }
        }
    });
    if (changed) saveProfileRecent(arr);
}

function getProfileRecent() { try { var r = localStorage.getItem(PROFILE_RECENT_KEY); return r ? JSON.parse(r) : []; } catch (e) { return []; } }
function saveProfileRecent(arr) { try { localStorage.setItem(PROFILE_RECENT_KEY, JSON.stringify(arr.slice(0, PROFILE_RECENT_MAX))); } catch (e) {} }
function addProfileToRecent(c) { var arr = getProfileRecent(); arr = arr.filter(function (x) { return x.identifier !== (c && c.identifier); }); arr.unshift({ identifier: c.identifier, firstname: c.firstname || "", lastname: c.lastname || "", onRedList: !!c.onRedList }); saveProfileRecent(arr); }

function profilesShowView(view) {
    if (profilesResultsWrap) profilesResultsWrap.classList.toggle("hidden", view !== "results");
    if (profilesDetail) profilesDetail.classList.toggle("hidden", view !== "detail");
    if (profilesSectionWrap) profilesSectionWrap.classList.toggle("hidden", view !== "section");
    if (profilesActionForm) profilesActionForm.classList.add("hidden");
    if (citizenPhotoModal) citizenPhotoModal.classList.add("hidden");
    if (view === "results") profilesRenderRecent();
}

function profilesBack() {
    if (profilesSectionWrap && !profilesSectionWrap.classList.contains("hidden")) { profilesShowView("detail"); return; }
    if (profilesDetail && !profilesDetail.classList.contains("hidden")) { profilesShowView("results"); return; }
    navigateTo("dashboard");
}

function profilesSearch() {
    if (profilesWantedActive) {
        profilesWantedActive = false;
        if (profilesWantedFilter) profilesWantedFilter.classList.remove("active");
    }
    var q = (profilesSearchInput && profilesSearchInput.value) ? profilesSearchInput.value.trim() : "";
    if (q.length < 4) { profilesRenderResults([]); return; }
    fetch("https://" + resourceName + "/searchCitizens", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
}

if (profilesWantedFilter) {
    profilesWantedFilter.addEventListener("click", function () {
        if (profilesWantedActive) {
            profilesWantedActive = false;
            profilesWantedFilter.classList.remove("active");
            profilesRenderResults([]);
            if (profilesSearchInput) profilesSearchInput.value = "";
            if (profilesRecentWrap) profilesRecentWrap.classList.remove("hidden");
            return;
        }
        profilesWantedActive = true;
        profilesWantedFilter.classList.add("active");
        if (profilesSearchInput) profilesSearchInput.value = "";
        if (profilesRecentWrap) profilesRecentWrap.classList.add("hidden");
        if (profilesResultsList) profilesResultsList.innerHTML = "<li style=\"text-align:center;color:var(--mdt-text2);padding:20px;font-size:13px;\">Chargement…</li>";
        fetch("https://" + resourceName + "/getWantedCitizens", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
    });
}

function profilesRenderResults(list) {
    if (!profilesResultsList) return;
    profilesResultsList.innerHTML = "";
    list.forEach(function (c) {
        var li = document.createElement("li");
        var btn = document.createElement("button");
        btn.type = "button"; btn.className = "result-item";
        var name = formatName(c.firstname, c.lastname);
        var wantedSvg = "<span class=\"result-wanted-badge\" title=\"Individu recherché\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z\"/><line x1=\"12\" y1=\"9\" x2=\"12\" y2=\"13\"/><line x1=\"12\" y1=\"17\" x2=\"12.01\" y2=\"17\"/></svg></span>";
        var labelHtml = escapeHtml(name) + (c.onRedList ? wantedSvg : "");
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"/><circle cx=\"12\" cy=\"7\" r=\"4\"/></svg></span><span class=\"result-label\">" + labelHtml + "</span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () {
            addProfileToRecent(c);
            profilesShowView("detail");
            fetch("https://" + resourceName + "/getCitizenProfile", { method: "POST", body: JSON.stringify({ identifier: c.identifier }) }).catch(function () {});
        });
        li.appendChild(btn);
        profilesResultsList.appendChild(li);
    });
    if (profilesRecentWrap) profilesRecentWrap.classList.toggle("hidden", list.length > 0);
}

function profilesRenderRecent() {
    if (!profilesRecentList) return;
    var recent = getProfileRecent();
    profilesRecentList.innerHTML = "";
    var wantedSvg = "<span class=\"result-wanted-badge\" title=\"Individu recherché\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z\"/><line x1=\"12\" y1=\"9\" x2=\"12\" y2=\"13\"/><line x1=\"12\" y1=\"17\" x2=\"12.01\" y2=\"17\"/></svg></span>";
    recent.forEach(function (c) {
        var li = document.createElement("li");
        var btn = document.createElement("button");
        btn.type = "button"; btn.className = "result-item";
        var name = formatName(c.firstname, c.lastname);
        var labelHtml = escapeHtml(name) + (c.onRedList ? wantedSvg : "");
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"/><circle cx=\"12\" cy=\"7\" r=\"4\"/></svg></span><span class=\"result-label\">" + labelHtml + "</span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () {
            profilesShowView("detail");
            fetch("https://" + resourceName + "/getCitizenProfile", { method: "POST", body: JSON.stringify({ identifier: c.identifier }) }).catch(function () {});
        });
        li.appendChild(btn);
        profilesRecentList.appendChild(li);
    });
    if (profilesRecentWrap) profilesRecentWrap.classList.toggle("hidden", recent.length === 0);
}

var vehicleRecherchePlates = new Set();
function isVehicleRecherche(veh) {
    if (!veh) return false;
    var s = veh.state;
    if (s === 1 || s === "1" || s === "out" || s === "recherche" || s === "recherché") return true;
    if (typeof s === "string" && s.toLowerCase().indexOf("recherche") !== -1) return true;
    return false;
}

var PROFILES_SECTIONS = [
    { id: "vehicles", title: "Véhicules", icon: "icon-vehicles", svgPath: "<path d=\"M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H8.5a1 1 0 0 0-.8.4L5 11l-4.16.86a1 1 0 0 0-.84.99V16h3\"/><circle cx=\"7\" cy=\"17\" r=\"2\"/><circle cx=\"17\" cy=\"17\" r=\"2\"/>",
        getRows: function (p) { return (p.vehicles || []).map(function (veh) { var plate = veh.plate || veh.plaque || ""; return { label: plate || "\u2014", plate: plate, isRecherche: isVehicleRecherche(veh) }; }); } },
    { id: "properties", title: "Propriétés", icon: "icon-properties", svgPath: "<path d=\"M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z\"/><polyline points=\"9 22 9 12 15 12 15 22\"/>",
        getRows: function (p) { return (p.properties || []).map(function (prop) { return { label: prop.name || prop.label || "\u2014", value: prop.price != null ? prop.price + " $" : "", propX: prop.x, propY: prop.y }; }); } },
    { id: "warrants", title: "Mandats d'arrêt", icon: "icon-warrants", svgPath: "<path d=\"M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z\"/><path d=\"M14 2v6h6\"/>",
        getRows: function (p) { return (p.warrants || []).map(function (x) { return { label: (x.reason || x.motif || "\u2014").toString(), value: x.created_at ? " (" + formatDate(x.created_at) + ")" : "" }; }); } },
    { id: "casier", title: "Casier judiciaire", icon: "icon-casier", svgPath: "<path d=\"M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z\"/><path d=\"M12 11v6\"/><path d=\"M9 14h6\"/>",
        getRows: function (p) { return (p.casier || []).map(function (x) { return { label: (x.entry || x.texte || "\u2014").toString(), value: x.created_at ? " " + formatDate(x.created_at) : "" }; }); } },
    { id: "reports", title: "Rapports", icon: "icon-reports", svgPath: "<path d=\"M12 20h9\"/><path d=\"M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z\"/>",
        getRows: function (p) { return (p.reports || []).map(function (x) { var t = (x.content || x.texte || "\u2014").toString(); return { label: t.substring(0, 60) + (t.length > 60 ? "\u2026" : ""), value: x.created_at ? " " + formatDate(x.created_at) : "" }; }); } }
];

function profilesOpenSection(sectionId) {
    if (!currentCitizenProfile || !profilesSectionTitle || !profilesSectionContent) return;
    var section = PROFILES_SECTIONS.find(function (s) { return s.id === sectionId; });
    if (!section) return;
    profilesSectionTitle.textContent = section.title;
    var rows = section.getRows(currentCitizenProfile);
    profilesSectionContent.innerHTML = "";
    var isVehicles = sectionId === "vehicles";
    var isProperties = sectionId === "properties";
    if (rows && rows.length > 0) {
        var card = document.createElement("div");
        card.className = "profile-card";
        var ul = document.createElement("ul");
        ul.className = "profile-card-list" + (isVehicles ? " vehicle-list" : "") + (isProperties ? " property-list" : "");
        rows.forEach(function (r) {
            var li = document.createElement("li");
            if (isProperties) li.style.cursor = "pointer";
            var labelSpan = document.createElement("span");
            labelSpan.className = "profile-card-label"; labelSpan.textContent = r.label || "\u2014";
            li.appendChild(labelSpan);
            if (r.value != null) { var vs = document.createElement("span"); vs.className = "profile-card-value"; vs.textContent = String(r.value); li.appendChild(vs); }
            if (isProperties) {
                var gpsIcon = document.createElement("span");
                gpsIcon.className = "property-gps-icon";
                if (r.propX != null && r.propY != null) {
                    gpsIcon.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z\"/><circle cx=\"12\" cy=\"10\" r=\"3\"/></svg>";
                    gpsIcon.title = "Ajouter au GPS";
                } else {
                    gpsIcon.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z\"/><line x1=\"12\" y1=\"8\" x2=\"12\" y2=\"12\"/><line x1=\"12\" y1=\"16\" x2=\"12.01\" y2=\"16\"/></svg>";
                    gpsIcon.title = "Enregistrer ma position comme coordonnées";
                    gpsIcon.classList.add("no-coords");
                }
                li.appendChild(gpsIcon);
                li.addEventListener("click", (function (row, label) {
                    return function () {
                        propertySetGPS(row.propX, row.propY, label);
                    };
                })(r, r.label));
            }
            if (isVehicles && r.plate) {
                var isWanted = vehiclesWantedData.some(function (w) { return w.plate === r.plate; });
                var btn = document.createElement("button");
                btn.type = "button";
                if (isWanted) {
                    btn.className = "btn-recherche on";
                    btn.textContent = "Recherché";
                    btn.disabled = true;
                } else {
                    btn.className = "btn-recherche";
                    btn.textContent = "Signaler";
                    btn.dataset.plate = r.plate;
                    btn.addEventListener("click", function (e) {
                        e.stopPropagation();
                        var plate = this.dataset.plate;
                        navigateTo("vehicles");
                        vehiclesFormReset();
                        if (vehiclesFormPlate) vehiclesFormPlate.value = plate;
                        if (vehiclesCreateForm) vehiclesCreateForm.classList.remove("hidden");
                        if (vehiclesResultsWrap) vehiclesResultsWrap.classList.add("hidden");
                    });
                }
                li.appendChild(btn);
            }
            ul.appendChild(li);
        });
        card.appendChild(ul);
        profilesSectionContent.appendChild(card);
    } else {
        profilesSectionContent.innerHTML = "<p class=\"section-empty\">Aucun élément.</p>";
    }
    profilesShowView("section");
}

/* ====== PROFILE DETAIL — ID CARD RENDER ====== */
function profilesRenderDetail(profile) {
    currentCitizenProfile = profile;
    if (!profileDetailScroll) return;
    profileDetailScroll.innerHTML = "";

    var fullName = formatName(profile.firstname, profile.lastname);

    /* --- ID Card --- */
    var card = document.createElement("div");
    card.className = "id-card";

    var top = document.createElement("div");
    top.className = "id-card-top";

    // Photo
    var photoDiv = document.createElement("div");
    photoDiv.className = "id-card-photo";
    photoDiv.title = "Cliquer pour ajouter/modifier la photo";
    if (profile.photo && profile.photo.trim()) {
        var photoImg = document.createElement("img");
        photoImg.src = profile.photo;
        photoImg.alt = fullName;
        photoImg.onerror = function () { this.remove(); };
        photoDiv.appendChild(photoImg);
    } else {
        photoDiv.innerHTML = "<div class=\"id-card-photo-placeholder\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.5\"><path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"/><circle cx=\"12\" cy=\"7\" r=\"4\"/></svg><span>Photo</span></div>";
    }
    photoDiv.addEventListener("click", function () {
        if (!citizenPhotoModal || !citizenPhotoInput) return;
        citizenPhotoInput.value = (currentCitizenProfile && currentCitizenProfile.photo) || "";
        citizenPhotoModal.classList.remove("hidden");
    });
    top.appendChild(photoDiv);

    // Info
    var infoDiv = document.createElement("div");
    infoDiv.className = "id-card-info";

    var nameEl = document.createElement("div");
    nameEl.className = "id-card-name";
    nameEl.textContent = fullName;
    infoDiv.appendChild(nameEl);

    var meta = document.createElement("div");
    meta.className = "id-card-meta";

    var metaItems = [
        { icon: "<path d=\"M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2z\"/>", label: "Naissance", value: profile.dateofbirth || profile.dob || "\u2014" },
        { icon: "<rect x=\"2\" y=\"7\" width=\"20\" height=\"14\" rx=\"2\"/><path d=\"M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16\"/>", label: "Emploi", value: profile.job || profile.job_label || "\u2014" },
        { icon: "<path d=\"M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2\"/><circle cx=\"12\" cy=\"7\" r=\"4\"/>", label: "ID", value: (profile.identifier || "\u2014").toString() }
    ];

    metaItems.forEach(function (mi) {
        var item = document.createElement("div");
        item.className = "id-card-meta-item";
        item.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\">" + mi.icon + "</svg><strong>" + escapeHtml(mi.value) + "</strong>";
        meta.appendChild(item);
    });
    infoDiv.appendChild(meta);

    // Badges
    var badges = document.createElement("div");
    badges.className = "id-card-badges";

    if (profile.onRedList) {
        badges.innerHTML += "<span class=\"id-badge id-badge-red\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z\"/></svg>RECHERCHÉ</span>";
    } else {
        badges.innerHTML += "<span class=\"id-badge id-badge-green\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><polyline points=\"20 6 9 17 4 12\"/></svg>RAS</span>";
    }
    var wCount = (profile.warrants || []).length;
    if (wCount > 0) {
        badges.innerHTML += "<span class=\"id-badge id-badge-red\">" + wCount + " mandat" + (wCount > 1 ? "s" : "") + "</span>";
    }
    var cCount = (profile.casier || []).length;
    if (cCount > 0) {
        badges.innerHTML += "<span class=\"id-badge id-badge-yellow\">" + cCount + " casier" + (cCount > 1 ? "s" : "") + "</span>";
    }
    var vCount = (profile.vehicles || []).length;
    if (vCount > 0) {
        badges.innerHTML += "<span class=\"id-badge id-badge-blue\">" + vCount + " véhicule" + (vCount > 1 ? "s" : "") + "</span>";
    }
    infoDiv.appendChild(badges);
    top.appendChild(infoDiv);
    card.appendChild(top);

    // Quick actions
    var actions = document.createElement("div");
    actions.className = "id-card-actions";

    function addIdAction(label, cls, cb, formTitle, keyReason) {
        var b = document.createElement("button");
        b.type = "button";
        b.className = "mdt-btn " + cls;
        b.textContent = label;
        b.addEventListener("click", function () {
            if (formTitle) {
                profilesPendingAction = { cb: cb, identifier: profile.identifier, keyReason: keyReason };
                if (profilesActionFormTitle) profilesActionFormTitle.textContent = formTitle;
                if (profilesActionFormInput) { profilesActionFormInput.value = ""; profilesActionFormInput.placeholder = formTitle + "\u2026"; }
                if (profilesActionForm) profilesActionForm.classList.remove("hidden");
            } else if (cb === "toggleRedList") {
                fetch("https://" + resourceName + "/citizenToggleRedList", { method: "POST", body: JSON.stringify({ identifier: profile.identifier }) }).catch(function () {});
            }
        });
        actions.appendChild(b);
    }

    // Mandat -> navigate to warrants page with create form
    var warrantBtn = document.createElement("button"); warrantBtn.type = "button"; warrantBtn.className = "mdt-btn mdt-btn-accent"; warrantBtn.textContent = "+ Mandat";
    warrantBtn.addEventListener("click", function () {
        pendingCreateTarget = { identifier: profile.identifier, firstname: profile.firstname, lastname: profile.lastname };
        navigateTo("warrants");
    });
    actions.appendChild(warrantBtn);
    // Casier -> navigate to casiers page with create form
    var casierBtn = document.createElement("button"); casierBtn.type = "button"; casierBtn.className = "mdt-btn mdt-btn-accent"; casierBtn.textContent = "+ Casier";
    casierBtn.addEventListener("click", function () {
        pendingCreateTarget = { identifier: profile.identifier, firstname: profile.firstname, lastname: profile.lastname };
        navigateTo("casiers");
    });
    actions.appendChild(casierBtn);
    // Rapport -> navigate to rapports page with create form
    var rapportBtn = document.createElement("button"); rapportBtn.type = "button"; rapportBtn.className = "mdt-btn mdt-btn-accent"; rapportBtn.textContent = "+ Rapport";
    rapportBtn.addEventListener("click", function () {
        pendingCreateTarget = { identifier: profile.identifier, firstname: profile.firstname, lastname: profile.lastname };
        navigateTo("rapports");
    });
    actions.appendChild(rapportBtn);
    addIdAction(profile.onRedList ? "Retirer recherché" : "Mettre recherché", profile.onRedList ? "mdt-btn-ghost" : "mdt-btn-danger", "toggleRedList", null, null);

    card.appendChild(actions);
    profileDetailScroll.appendChild(card);

    /* --- Section Cards Grid --- */
    var grid = document.createElement("div");
    grid.className = "profile-sections";

    PROFILES_SECTIONS.forEach(function (s) {
        var count = s.getRows(profile).length;
        var sc = document.createElement("div");
        sc.className = "section-card";
        sc.innerHTML = "<div class=\"section-card-icon " + s.icon + "\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\">" + s.svgPath + "</svg></div>" +
            "<div class=\"section-card-body\"><div class=\"section-card-title\">" + escapeHtml(s.title) + "</div><div class=\"section-card-count\">" + count + " élément" + (count !== 1 ? "s" : "") + "</div></div>" +
            "<div class=\"section-card-chevron\"></div>";
        sc.addEventListener("click", function () { profilesOpenSection(s.id); });
        grid.appendChild(sc);
    });

    profileDetailScroll.appendChild(grid);
}

function profilesActionFormSubmitClick() {
    if (!profilesPendingAction || !profilesActionFormInput) return;
    var text = profilesActionFormInput.value.trim(); if (!text) return;
    var data = { identifier: profilesPendingAction.identifier };
    data[profilesPendingAction.keyReason] = text;
    fetch("https://" + resourceName + "/" + profilesPendingAction.cb, { method: "POST", body: JSON.stringify(data) }).catch(function () {});
    profilesActionForm.classList.add("hidden"); profilesPendingAction = null;
}

if (profilesSearchInput) {
    profilesSearchInput.addEventListener("input", function () {
        if (profilesSearchDebounce) clearTimeout(profilesSearchDebounce);
        profilesSearchDebounce = setTimeout(profilesSearch, 500);
    });
    profilesSearchInput.addEventListener("keydown", function (e) {
        if (e.key === "Escape") { profilesBack(); }
    });
}
if (profilesActionFormCancel) profilesActionFormCancel.addEventListener("click", function () { profilesActionForm.classList.add("hidden"); profilesPendingAction = null; });
if (profilesActionFormSubmit) profilesActionFormSubmit.addEventListener("click", profilesActionFormSubmitClick);
var btnBackProfilesSection = document.getElementById("btnBackProfilesSection");
if (btnBackProfilesSection) btnBackProfilesSection.addEventListener("click", profilesBack);

/* Citizen photo modal */
if (citizenPhotoCancelBtn) citizenPhotoCancelBtn.addEventListener("click", function () { citizenPhotoModal.classList.add("hidden"); });
if (citizenPhotoSaveBtn) citizenPhotoSaveBtn.addEventListener("click", function () {
    if (!currentCitizenProfile || !citizenPhotoInput) return;
    var url = citizenPhotoInput.value.trim();
    fetch("https://" + resourceName + "/setCitizenPhoto", { method: "POST", body: JSON.stringify({ identifier: currentCitizenProfile.identifier, url: url }) }).catch(function () {});
    citizenPhotoModal.classList.add("hidden");
});

/* ====== PROPERTY GPS PIN ====== */
function propertySetGPS(propX, propY, propertyName) {
    var payload = { propertyName: propertyName || "" };
    if (propX != null && propY != null) {
        payload.x = propX;
        payload.y = propY;
    }
    fetch("https://" + resourceName + "/propertyGPS", { method: "POST", body: JSON.stringify(payload) })
        .then(function (r) { return r.json(); })
        .then(function (res) {
            if (res && res.ok) {
                if (res.action === "pinned") {
                    showToast("Position enregistrée et ajoutée au GPS");
                    if (currentCitizenProfile && res.x != null) {
                        var props = currentCitizenProfile.properties || [];
                        for (var i = 0; i < props.length; i++) {
                            if ((props[i].name || "") === propertyName) {
                                props[i].x = res.x;
                                props[i].y = res.y;
                                props[i].z = res.z;
                                break;
                            }
                        }
                    }
                } else {
                    showToast("Coordonnées ajoutées au GPS");
                }
            }
        })
        .catch(function () {
            showToast("Coordonnées ajoutées au GPS");
        });
}

/* ====== VEHICLES ====== */
var vehiclesSearchInput = document.getElementById("vehiclesSearchInput");
var vehiclesResultsList = document.getElementById("vehiclesResultsList");
var vehiclesResultsWrap = document.getElementById("vehiclesResultsWrap");
var vehiclesWantedList = document.getElementById("vehiclesWantedList");
var vehiclesWantedHint = document.getElementById("vehiclesWantedHint");
var vehiclesSearchResultsSection = document.getElementById("vehiclesSearchResultsSection");
var vehiclesRecentWrap = document.getElementById("vehiclesRecentWrap");
var vehiclesRecentList = document.getElementById("vehiclesRecentList");
var btnVehiclesAddWanted = document.getElementById("btnVehiclesAddWanted");
var vehiclesCreateForm = document.getElementById("vehiclesCreateForm");
var vehiclesFormPlate = document.getElementById("vehiclesFormPlate");
var vehiclesFormReason = document.getElementById("vehiclesFormReason");
var vehiclesFormDescription = document.getElementById("vehiclesFormDescription");
var vehiclesFormCancel = document.getElementById("vehiclesFormCancel");
var vehiclesFormSubmit = document.getElementById("vehiclesFormSubmit");
var vehiclesFormBack = document.getElementById("btnVehiclesFormBack");
var vehiclesDetailPanel = document.getElementById("vehiclesDetailPanel");
var vehiclesDetailContent = document.getElementById("vehiclesDetailContent");
var vehiclesDetailBack = document.getElementById("btnVehiclesDetailBack");
var vehiclesWantedData = [];
var VEHICLE_RECENT_KEY = "SNL_PolTablet-recent-vehicles";

function getVehicleRecent() { try { return JSON.parse(localStorage.getItem(VEHICLE_RECENT_KEY)) || []; } catch (e) { return []; } }
function saveVehicleRecent(arr) { try { localStorage.setItem(VEHICLE_RECENT_KEY, JSON.stringify(arr.slice(0, 10))); } catch (e) {} }
function addVehicleRecent(plate) { var arr = getVehicleRecent(); arr = arr.filter(function (p) { return p !== plate; }); arr.unshift(plate); saveVehicleRecent(arr); }

function vehiclesLoadWanted() {
    fetch("https://" + resourceName + "/getWantedVehicles", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
    vehiclesRenderRecent();
}

function vehiclesRenderRecent() {
    if (!vehiclesRecentList) return;
    var recent = getVehicleRecent();
    vehiclesRecentList.innerHTML = "";
    if (recent.length === 0) { if (vehiclesRecentWrap) vehiclesRecentWrap.classList.add("hidden"); return; }
    if (vehiclesRecentWrap) vehiclesRecentWrap.classList.remove("hidden");
    recent.forEach(function (plate) {
        var li = document.createElement("li");
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item";
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H8.5a1 1 0 0 0-.8.4L5 11l-4.16.86a1 1 0 0 0-.84.99V16h3\"/><circle cx=\"7\" cy=\"17\" r=\"2\"/><circle cx=\"17\" cy=\"17\" r=\"2\"/></svg></span><span class=\"result-label\">" + escapeHtml(plate) + "</span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () {
            if (vehiclesSearchInput) vehiclesSearchInput.value = plate;
            vehiclesSearch();
        });
        li.appendChild(btn); vehiclesRecentList.appendChild(li);
    });
}

function vehiclesRenderWanted(list) {
    vehiclesWantedData = list || [];
    if (!vehiclesWantedList) return;
    vehiclesWantedList.innerHTML = "";
    if (vehiclesWantedHint) vehiclesWantedHint.classList.toggle("hidden", list.length > 0);
    list.forEach(function (v) {
        var li = document.createElement("li");
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item";
        var reasonHint = v.reason ? " — " + escapeHtml(v.reason.substring(0, 40)) + (v.reason.length > 40 ? "…" : "") : "";
        btn.innerHTML = "<span class=\"result-icon\" style=\"background:rgba(255,69,58,.15)\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"var(--mdt-red)\" stroke-width=\"2\"><path d=\"M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z\"/><line x1=\"12\" y1=\"9\" x2=\"12\" y2=\"13\"/><line x1=\"12\" y1=\"17\" x2=\"12.01\" y2=\"17\"/></svg></span>" +
            "<span class=\"result-meta\"><span class=\"result-label\">" + escapeHtml(v.plate) + "</span><span class=\"result-sub\">" + (reasonHint ? escapeHtml(v.reason.substring(0, 60)) : "Aucun motif") + "</span></span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () { vehiclesShowDetail(v); });
        li.appendChild(btn);
        vehiclesWantedList.appendChild(li);
    });
}

function vehiclesShowDetail(v) {
    if (!vehiclesDetailContent || !vehiclesDetailPanel) return;
    var html = "<div class=\"detail-card\"><div class=\"detail-header\"><div class=\"detail-icon\" style=\"background:rgba(255,69,58,.15)\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"var(--mdt-red)\" stroke-width=\"2\"><path d=\"M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H8.5a1 1 0 0 0-.8.4L5 11l-4.16.86a1 1 0 0 0-.84.99V16h3\"/><circle cx=\"7\" cy=\"17\" r=\"2\"/><circle cx=\"17\" cy=\"17\" r=\"2\"/></svg></div>" +
        "<div class=\"detail-title\"><h3>" + escapeHtml(v.plate) + "</h3><p>Véhicule recherché</p></div></div><div class=\"detail-body\">";
    if (v.reason) html += "<div class=\"detail-field\"><span class=\"detail-label\">Motif</span><div class=\"detail-value\">" + escapeHtml(v.reason) + "</div></div>";
    if (v.description) html += "<div class=\"detail-field\"><span class=\"detail-label\">Description</span><div class=\"detail-value\">" + escapeHtml(v.description) + "</div></div>";
    if (v.issued_by_name || v.added_by) html += "<div class=\"detail-field\"><span class=\"detail-label\">Signalé par</span><div class=\"detail-value\">" + escapeHtml(v.issued_by_name || v.added_by || "") + "</div></div>";
    if (v.added_at) html += "<div class=\"detail-field\"><span class=\"detail-label\">Date</span><div class=\"detail-value\">" + escapeHtml(formatDate(v.added_at)) + "</div></div>";
    html += "</div><div class=\"detail-actions\">";
    html += "<button type=\"button\" class=\"mdt-btn mdt-btn-danger\" id=\"vehicleRemoveWantedBtn\">Retirer des recherchés</button>";
    html += "<button type=\"button\" class=\"mdt-btn mdt-btn-ghost\" id=\"vehicleDetailCloseBtn\">Fermer</button>";
    html += "</div></div>";
    vehiclesDetailContent.innerHTML = html;
    var rmBtn = document.getElementById("vehicleRemoveWantedBtn");
    rmBtn.addEventListener("click", function () {
        if (this.dataset.confirm === "1") {
            fetch("https://" + resourceName + "/removeWantedVehicle", { method: "POST", body: JSON.stringify({ plate: v.plate }) }).catch(function () {});
            return;
        }
        this.dataset.confirm = "1";
        this.textContent = "Confirmer la suppression ?";
        var self = this;
        setTimeout(function () { self.dataset.confirm = ""; self.textContent = "Retirer des recherchés"; }, 3000);
    });
    document.getElementById("vehicleDetailCloseBtn").addEventListener("click", function () {
        vehiclesDetailPanel.classList.add("hidden");
        vehiclesResultsWrap.classList.remove("hidden");
    });
    vehiclesResultsWrap.classList.add("hidden");
    if (vehiclesCreateForm) vehiclesCreateForm.classList.add("hidden");
    vehiclesDetailPanel.classList.remove("hidden");
}

function vehiclesFormReset() {
    if (vehiclesFormPlate) vehiclesFormPlate.value = "";
    if (vehiclesFormReason) vehiclesFormReason.value = "";
    if (vehiclesFormDescription) vehiclesFormDescription.value = "";
}

function vehiclesSearch() {
    var q = (vehiclesSearchInput && vehiclesSearchInput.value) ? vehiclesSearchInput.value.trim() : "";
    if (!q) { if (vehiclesSearchResultsSection) vehiclesSearchResultsSection.classList.add("hidden"); return; }
    addVehicleRecent(q.toUpperCase());
    if (vehiclesResultsList) vehiclesResultsList.innerHTML = "";
    if (vehiclesSearchResultsSection) vehiclesSearchResultsSection.classList.remove("hidden");
    fetch("https://" + resourceName + "/searchVehicleByPlate", { method: "POST", body: JSON.stringify({ plate: q }) }).catch(function () {});
}

function vehiclesRenderResults(list) {
    if (!vehiclesResultsList) return;
    vehiclesResultsList.innerHTML = "";
    if (vehiclesSearchResultsSection) vehiclesSearchResultsSection.classList.remove("hidden");
    if (!list || list.length === 0) { vehiclesResultsList.innerHTML = "<li style=\"padding:12px;color:var(--mdt-text2);font-size:14px;\">Aucun véhicule trouvé.</li>"; return; }
    list.forEach(function (item) {
        var li = document.createElement("li");
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item";
        var ownerName = formatName(item.firstname, item.lastname);
        if (ownerName === "\u2014") ownerName = "";
        var label = escapeHtml(item.plate || "\u2014") + " — " + escapeHtml(ownerName || "Abandonné");
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M14 16H9m10 0h3v-3.15a1 1 0 0 0-.84-.99L16 11l-2.7-3.6a1 1 0 0 0-.8-.4H8.5a1 1 0 0 0-.8.4L5 11l-4.16.86a1 1 0 0 0-.84.99V16h3\"/><circle cx=\"7\" cy=\"17\" r=\"2\"/><circle cx=\"17\" cy=\"17\" r=\"2\"/></svg></span><span class=\"result-label\">" + label + "</span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () {
            if (item.identifier) {
                navigateTo("profiles");
                profilesShowView("detail");
                fetch("https://" + resourceName + "/getCitizenProfile", { method: "POST", body: JSON.stringify({ identifier: item.identifier }) }).catch(function () {});
            }
        });
        li.appendChild(btn); vehiclesResultsList.appendChild(li);
    });
    vehiclesRenderRecent();
}

var vehicleSuggestions = document.getElementById("vehicleSuggestions");
var vehicleSuggestDebounce = null;

function vehiclesHideSuggestions() { if (vehicleSuggestions) vehicleSuggestions.classList.add("hidden"); }

function vehiclesRenderSuggestions(list) {
    if (!vehicleSuggestions) return;
    vehicleSuggestions.innerHTML = "";
    if (!list || list.length === 0) { vehiclesHideSuggestions(); return; }
    list.forEach(function (item) {
        var li = document.createElement("li");
        var btn = document.createElement("button");
        btn.type = "button";
        btn.className = "vehicle-suggest-item";
        var ownerName = formatName(item.firstname, item.lastname);
        if (ownerName === "\u2014") ownerName = "";
        var displayOwner = ownerName || "Abandonné";
        btn.innerHTML = "<span class=\"vehicle-suggest-plate\">" + escapeHtml(item.plate || "") + "</span><span class=\"vehicle-suggest-owner\">" + escapeHtml(displayOwner) + "</span>";
        btn.addEventListener("click", function () {
            if (vehiclesSearchInput) vehiclesSearchInput.value = item.plate || "";
            vehiclesHideSuggestions();
            vehiclesSearch();
        });
        li.appendChild(btn);
        vehicleSuggestions.appendChild(li);
    });
    vehicleSuggestions.classList.remove("hidden");
}

if (vehiclesSearchInput) {
    vehiclesSearchInput.addEventListener("input", function () {
        var val = this.value.trim();
        if (val.length < 3) { vehiclesHideSuggestions(); return; }
        if (vehicleSuggestDebounce) clearTimeout(vehicleSuggestDebounce);
        vehicleSuggestDebounce = setTimeout(function () {
            fetch("https://" + resourceName + "/suggestVehicleByPlate", { method: "POST", body: JSON.stringify({ partial: val }) }).catch(function () {});
        }, 300);
    });
    vehiclesSearchInput.addEventListener("keydown", function (e) {
        if (e.key === "Enter") { e.preventDefault(); vehiclesHideSuggestions(); vehiclesSearch(); }
        if (e.key === "Escape") { vehiclesHideSuggestions(); }
    });
    vehiclesSearchInput.addEventListener("blur", function () { setTimeout(vehiclesHideSuggestions, 200); });
}
if (btnVehiclesAddWanted) btnVehiclesAddWanted.addEventListener("click", function () {
    vehiclesFormReset();
    if (vehiclesCreateForm) vehiclesCreateForm.classList.remove("hidden");
    if (vehiclesResultsWrap) vehiclesResultsWrap.classList.add("hidden");
    if (vehiclesDetailPanel) vehiclesDetailPanel.classList.add("hidden");
});
if (vehiclesFormBack) vehiclesFormBack.addEventListener("click", function () { if (vehiclesCreateForm) vehiclesCreateForm.classList.add("hidden"); if (vehiclesResultsWrap) vehiclesResultsWrap.classList.remove("hidden"); });
if (vehiclesFormCancel) vehiclesFormCancel.addEventListener("click", function () { if (vehiclesCreateForm) vehiclesCreateForm.classList.add("hidden"); if (vehiclesResultsWrap) vehiclesResultsWrap.classList.remove("hidden"); });
if (vehiclesFormSubmit) vehiclesFormSubmit.addEventListener("click", function () {
    var plate = vehiclesFormPlate ? vehiclesFormPlate.value.trim().toUpperCase() : "";
    var reason = vehiclesFormReason ? vehiclesFormReason.value.trim() : "";
    var description = vehiclesFormDescription ? vehiclesFormDescription.value.trim() : "";
    if (!plate) { showToast("Plaque requise"); return; }
    if (!reason) { showToast("Motif requis"); return; }
    fetch("https://" + resourceName + "/addWantedVehicle", { method: "POST", body: JSON.stringify({ plate: plate, reason: reason, description: description }) }).catch(function () {});
    if (vehiclesCreateForm) vehiclesCreateForm.classList.add("hidden");
    if (vehiclesResultsWrap) vehiclesResultsWrap.classList.remove("hidden");
});
if (vehiclesDetailBack) vehiclesDetailBack.addEventListener("click", function () { if (vehiclesDetailPanel) vehiclesDetailPanel.classList.add("hidden"); if (vehiclesResultsWrap) vehiclesResultsWrap.classList.remove("hidden"); });

/* ====== WARRANTS ====== */
var warrantsSearchInput = document.getElementById("warrantsSearchInput");
var warrantsResultsList = document.getElementById("warrantsResultsList");
var warrantsResultsWrap = document.getElementById("warrantsResultsWrap");
var warrantsHint = document.getElementById("warrantsHint");
var btnWarrantsCreate = document.getElementById("btnWarrantsCreate");
var warrantsCreateForm = document.getElementById("warrantsCreateForm");
var warrantDetailPanel = document.getElementById("warrantDetailPanel");
var warrantDetailContent = document.getElementById("warrantDetailContent");
var btnWarrantDetailBack = document.getElementById("btnWarrantDetailBack");
var warrantsTargetSearch = document.getElementById("warrantsTargetSearch");
var warrantsTargetSelected = document.getElementById("warrantsTargetSelected");
var warrantsTargetResults = document.getElementById("warrantsTargetResults");
var btnWarrantsTargetClear = document.getElementById("btnWarrantsTargetClear");
var warrantsFormReason = document.getElementById("warrantsFormReason");
var warrantsFormDescription = document.getElementById("warrantsFormDescription");
var warrantsFormPhotosGrid = document.getElementById("warrantsFormPhotosGrid");
var btnWarrantsFormCancel = document.getElementById("btnWarrantsFormCancel");
var btnWarrantsFormSubmit = document.getElementById("btnWarrantsFormSubmit");
var warrantsFormPhotos = [];
var warrantsSelectedTarget = null;
var warrantsTargetSearchDebounce = null;
var warrantsTargetSearching = false;

// Cache client + throttle : la liste des mandats actifs est globale et ne
// change pas entre deux ouvertures rapprochées. On évite de refetch le serveur
// à chaque changement d'onglet (< LIST_REFETCH_MS) et on re-render la dernière
// liste reçue. force=true (après create/edit/delete) court-circuite le cache.
var LIST_REFETCH_MS = 15000;
var warrantsLastList = null, warrantsLastAt = 0;

function warrantsLoadActive(force) {
    if (!force && warrantsLastList && (Date.now() - warrantsLastAt) < LIST_REFETCH_MS) {
        warrantsRenderResults(warrantsLastList);
        return;
    }
    if (warrantsHint) { warrantsHint.textContent = "Chargement des mandats\u2026"; warrantsHint.classList.remove("hidden"); }
    if (warrantsResultsList) warrantsResultsList.innerHTML = "";
    fetch("https://" + resourceName + "/getActiveWarrants", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
}

function warrantsOpenCreateWithTarget(target) {
    warrantsFormReset();
    warrantsSelectedTarget = target;
    var name = formatName(target.firstname, target.lastname);
    if (warrantsTargetSelected) { warrantsTargetSelected.textContent = name + " \u2014 " + (target.identifier || ""); warrantsTargetSelected.classList.remove("hidden"); }
    if (warrantsCreateForm) warrantsCreateForm.classList.remove("hidden");
    if (warrantsResultsWrap) warrantsResultsWrap.classList.add("hidden");
}

function warrantsSearch() {
    var q = (warrantsSearchInput && warrantsSearchInput.value) ? warrantsSearchInput.value.trim() : "";
    if (!q) { warrantsLoadActive(); return; }
    if (warrantsHint) { warrantsHint.textContent = "Recherche\u2026"; warrantsHint.classList.remove("hidden"); }
    if (warrantsResultsList) warrantsResultsList.innerHTML = "";
    fetch("https://" + resourceName + "/searchWarrants", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
}

function warrantsPhotosRender() {
    if (!warrantsFormPhotosGrid) return;
    warrantsFormPhotosGrid.innerHTML = "";
    warrantsFormPhotos.forEach(function (url, idx) {
        var thumb = document.createElement("div");
        thumb.className = "casier-photo-thumb";
        var img = document.createElement("img"); img.src = url; img.alt = "";
        var del = document.createElement("button"); del.type = "button"; del.className = "casier-photo-remove"; del.textContent = "\u00d7"; del.title = "Retirer";
        del.addEventListener("click", function () { warrantsFormPhotos.splice(idx, 1); warrantsPhotosRender(); });
        thumb.appendChild(img); thumb.appendChild(del);
        warrantsFormPhotosGrid.appendChild(thumb);
    });
}

function openGalleryPickerForWarrants() {
    if (!galleryPickerModal || !galleryPickerGrid || !galleryPickerHint) return;
    var g = photoGetGallery();
    galleryPickerHint.classList.toggle("hidden", g.length > 0);
    galleryPickerGrid.innerHTML = "";
    g.forEach(function (url) {
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "photo-pick-item";
        if (warrantsFormPhotos.indexOf(url) >= 0) btn.classList.add("selected");
        var img = document.createElement("img"); img.src = url; img.alt = "";
        btn.appendChild(img);
        btn.addEventListener("click", function () {
            if (warrantsFormPhotos.indexOf(url) === -1) {
                warrantsFormPhotos.push(url);
                btn.classList.add("selected");
            }
            warrantsPhotosRender();
            galleryPickerModal.classList.add("hidden");
        });
        galleryPickerGrid.appendChild(btn);
    });
    galleryPickerModal.classList.remove("hidden");
}

function warrantsFormReset() {
    warrantsSelectedTarget = null;
    if (warrantsTargetSelected) { warrantsTargetSelected.textContent = ""; warrantsTargetSelected.classList.add("hidden"); }
    if (warrantsTargetResults) { warrantsTargetResults.innerHTML = ""; warrantsTargetResults.classList.add("hidden"); }
    if (warrantsTargetSearch) { warrantsTargetSearch.value = ""; warrantsTargetSearch.disabled = false; }
    if (warrantsFormReason) warrantsFormReason.value = "";
    if (warrantsFormDescription) warrantsFormDescription.value = "";
    warrantsFormPhotos = [];
    if (warrantsFormPhotosGrid) warrantsFormPhotosGrid.innerHTML = "";
    if (warrantsCreateForm) warrantsCreateForm._editId = null;
}

function warrantShowDetail(w) {
    if (!warrantDetailContent || !warrantDetailPanel) return;
    warrantDetailContent.innerHTML = "";

    var name = (w.firstname || w.lastname) ? formatName(w.firstname, w.lastname) : (w.identifier || "\u2014");

    var card = document.createElement("div");
    card.className = "warrant-detail-card";

    // Header
    var header = document.createElement("div");
    header.className = "warrant-detail-header";
    header.innerHTML = "<div class=\"warrant-detail-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z\"/><path d=\"M14 2v6h6\"/></svg></div>" +
        "<div class=\"warrant-detail-title\"><h3>Mandat #" + escapeHtml(String(w.id || "?")) + "</h3><p>" + escapeHtml(name) + "</p></div>";
    card.appendChild(header);

    // Body
    var body = document.createElement("div");
    body.className = "warrant-detail-body";

    function addField(label, value) {
        if (!value || !value.trim()) return;
        var f = document.createElement("div");
        f.className = "warrant-detail-field";
        f.innerHTML = "<span class=\"warrant-detail-label\">" + escapeHtml(label) + "</span><div class=\"warrant-detail-value\">" + escapeHtml(value) + "</div>";
        body.appendChild(f);
    }

    addField("Motif", w.reason || "");
    addField("Description", w.description || "");
    addField("Émis par", w.issued_by || "");
    addField("Date", w.created_at ? formatDate(w.created_at) : "");

    // Images
    var images = [];
    if (w.images) {
        try {
            var parsed = typeof w.images === "string" ? JSON.parse(w.images) : w.images;
            if (Array.isArray(parsed)) images = parsed.filter(function (u) { return u && u.trim(); });
        } catch (e) {}
    }
    if (images.length > 0) {
        var imgField = document.createElement("div");
        imgField.className = "warrant-detail-field";
        imgField.innerHTML = "<span class=\"warrant-detail-label\">Images</span>";
        var imgWrap = document.createElement("div");
        imgWrap.className = "warrant-detail-images";
        images.forEach(function (url) {
            var img = document.createElement("img");
            img.src = url;
            img.alt = "Evidence";
            img.addEventListener("click", function () { openLightbox(url); });
            img.onerror = function () { this.style.display = "none"; };
            imgWrap.appendChild(img);
        });
        imgField.appendChild(imgWrap);
        body.appendChild(imgField);
    }

    card.appendChild(body);

    // Actions
    var actions = document.createElement("div");
    actions.className = "warrant-detail-actions";
    var viewProfileBtn = document.createElement("button");
    viewProfileBtn.type = "button";
    viewProfileBtn.className = "mdt-btn mdt-btn-primary";
    viewProfileBtn.textContent = "Voir le profil du citoyen";
    viewProfileBtn.addEventListener("click", function () {
        navigateTo("profiles");
        profilesShowView("detail");
        fetch("https://" + resourceName + "/getCitizenProfile", { method: "POST", body: JSON.stringify({ identifier: w.identifier }) }).catch(function () {});
    });
    actions.appendChild(viewProfileBtn);

    if (playerGradeLevel >= 8) {
        var editWarrantBtn = document.createElement("button");
        editWarrantBtn.type = "button";
        editWarrantBtn.className = "mdt-btn mdt-btn-accent";
        editWarrantBtn.textContent = "Modifier";
        editWarrantBtn.addEventListener("click", function () {
            warrantsFormReset();
            warrantsSelectedTarget = { identifier: w.identifier, firstname: w.firstname, lastname: w.lastname };
            var wName = (w.firstname || w.lastname) ? formatName(w.firstname, w.lastname) : (w.identifier || "");
            if (warrantsTargetSelected) { warrantsTargetSelected.textContent = wName + " \u2014 " + (w.identifier || ""); warrantsTargetSelected.classList.remove("hidden"); }
            if (warrantsTargetSearch) warrantsTargetSearch.disabled = true;
            if (warrantsFormReason) warrantsFormReason.value = w.reason || "";
            if (warrantsFormDescription) warrantsFormDescription.value = w.description || "";
            warrantsFormPhotos = images.slice();
            warrantsPhotosRender();
            if (warrantsCreateForm) warrantsCreateForm.classList.remove("hidden");
            if (warrantDetailPanel) warrantDetailPanel.classList.add("hidden");
            warrantsCreateForm._editId = w.id;
        });
        actions.appendChild(editWarrantBtn);
    }

    var delBtn = document.createElement("button");
    delBtn.type = "button";
    delBtn.className = "mdt-btn mdt-btn-danger";
    delBtn.textContent = "Supprimer le mandat";
    delBtn.addEventListener("click", function () {
        if (deleteLimitReached()) { showToast("Limite de suppressions atteinte (" + SESSION_DELETE_MAX + "/session)"); return; }
        if (this.dataset.confirm === "1") {
            fetch("https://" + resourceName + "/deleteWarrant", { method: "POST", body: JSON.stringify({ id: w.id }) }).catch(function () {});
            return;
        }
        this.dataset.confirm = "1";
        this.textContent = "Confirmer ?";
        var self = this;
        setTimeout(function () { self.dataset.confirm = ""; self.textContent = "Supprimer le mandat"; }, 3000);
    });
    actions.appendChild(delBtn);

    var closeBtn = document.createElement("button");
    closeBtn.type = "button";
    closeBtn.className = "mdt-btn mdt-btn-ghost";
    closeBtn.textContent = "Fermer";
    closeBtn.addEventListener("click", function () {
        warrantDetailPanel.classList.add("hidden");
        warrantsResultsWrap.classList.remove("hidden");
    });
    actions.appendChild(closeBtn);
    card.appendChild(actions);

    warrantDetailContent.appendChild(card);
    warrantsResultsWrap.classList.add("hidden");
    if (warrantsCreateForm) warrantsCreateForm.classList.add("hidden");
    warrantDetailPanel.classList.remove("hidden");
}

function warrantsRenderResults(list) {
    if (!warrantsResultsList) return;
    warrantsResultsList.innerHTML = "";
    if (warrantsHint) warrantsHint.classList.add("hidden");
    var statMandatsEl = document.getElementById("statMandats");
    if (statMandatsEl && list) statMandatsEl.textContent = list.length;
    if (!list || list.length === 0) { if (warrantsHint) { warrantsHint.textContent = "Aucun mandat trouvé."; warrantsHint.classList.remove("hidden"); } return; }
    list.forEach(function (w) {
        var li = document.createElement("li");
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item";
        var name = (w.firstname || w.lastname) ? formatName(w.firstname, w.lastname) : (w.identifier || "\u2014");
        var reason = (w.reason || "").toString().substring(0, 50); if ((w.reason || "").length > 50) reason += "\u2026";
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z\"/><path d=\"M14 2v6h6\"/></svg></span><span class=\"result-label\">" + escapeHtml(name) + " \u2014 " + escapeHtml(reason) + "</span><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () { warrantShowDetail(w); });
        li.appendChild(btn); warrantsResultsList.appendChild(li);
    });
}

if (warrantsSearchInput) warrantsSearchInput.addEventListener("keydown", function (e) { if (e.key === "Enter") { e.preventDefault(); warrantsSearch(); } });
if (btnWarrantsCreate) btnWarrantsCreate.addEventListener("click", function () { warrantsFormReset(); if (warrantDetailPanel) warrantDetailPanel.classList.add("hidden"); if (warrantsCreateForm) warrantsCreateForm.classList.remove("hidden"); if (warrantsResultsWrap) warrantsResultsWrap.classList.add("hidden"); });
if (btnWarrantsFormCancel) btnWarrantsFormCancel.addEventListener("click", function () { if (warrantsCreateForm) warrantsCreateForm.classList.add("hidden"); if (warrantsResultsWrap) warrantsResultsWrap.classList.remove("hidden"); });
if (btnWarrantDetailBack) btnWarrantDetailBack.addEventListener("click", function () { if (warrantDetailPanel) warrantDetailPanel.classList.add("hidden"); if (warrantsResultsWrap) warrantsResultsWrap.classList.remove("hidden"); });
if (btnWarrantsTargetClear) btnWarrantsTargetClear.addEventListener("click", function () {
    warrantsSelectedTarget = null;
    if (warrantsTargetSelected) { warrantsTargetSelected.textContent = ""; warrantsTargetSelected.classList.add("hidden"); }
    if (warrantsTargetSearch) warrantsTargetSearch.value = "";
    if (warrantsTargetResults) warrantsTargetResults.classList.add("hidden");
});
if (warrantsTargetSearch) warrantsTargetSearch.addEventListener("input", function () {
    clearTimeout(warrantsTargetSearchDebounce);
    var q = this.value.trim();
    if (q.length < 4) { if (warrantsTargetResults) { warrantsTargetResults.innerHTML = ""; warrantsTargetResults.classList.add("hidden"); } return; }
    warrantsTargetSearchDebounce = setTimeout(function () {
        warrantsTargetSearching = true;
        fetch("https://" + resourceName + "/searchCitizens", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
    }, 500);
});
if (btnWarrantsFormSubmit) btnWarrantsFormSubmit.addEventListener("click", function () {
    if (!warrantsSelectedTarget || !warrantsSelectedTarget.identifier) return;
    var reason = (warrantsFormReason && warrantsFormReason.value) ? warrantsFormReason.value.trim() : "";
    var description = (warrantsFormDescription && warrantsFormDescription.value) ? warrantsFormDescription.value.trim() : "";
    var imagesArr = warrantsFormPhotos.slice();
    var editId = warrantsCreateForm && warrantsCreateForm._editId;
    if (editId) {
        fetch("https://" + resourceName + "/editWarrant", { method: "POST", body: JSON.stringify({ id: editId, reason: reason, description: description, images: imagesArr }) }).catch(function () {});
    } else {
        fetch("https://" + resourceName + "/createWarrant", { method: "POST", body: JSON.stringify({ identifier: warrantsSelectedTarget.identifier, reason: reason, description: description, images: imagesArr }) }).catch(function () {});
    }
});

/* ====== DASHBOARD SEARCH SHORTCUTS ====== */
/* ====== QUICK SEARCH ====== */
var quickSearchInput = document.getElementById("quickSearchInput");
var quickSearchBtn = document.getElementById("quickSearchBtn");
var quickSearchFilters = document.getElementById("quickSearchFilters");
var activeQuickFilter = "citoyens";

if (quickSearchFilters) {
    var filterBtns = quickSearchFilters.querySelectorAll(".qs-filter");
    filterBtns.forEach(function (fb) {
        fb.addEventListener("click", function () {
            filterBtns.forEach(function (b) { b.classList.remove("active"); });
            fb.classList.add("active");
            activeQuickFilter = fb.getAttribute("data-filter");
            var placeholders = { citoyens: "Nom, prénom…", vehicules: "Plaque d'immatriculation…", mandats: "Nom du suspect…", casiers: "Nom ou infraction…", rapports: "Titre ou contenu…" };
            if (quickSearchInput) quickSearchInput.placeholder = placeholders[activeQuickFilter] || "Rechercher…";
        });
    });
}

function quickSearchExecute() {
    var q = quickSearchInput ? quickSearchInput.value.trim() : "";
    if (!q) return;
    if (activeQuickFilter === "citoyens") {
        navigateTo("profiles");
        if (profilesSearchInput) { profilesSearchInput.value = q; }
        profilesSearch();
    } else if (activeQuickFilter === "vehicules") {
        navigateTo("vehicles");
        if (vehiclesSearchInput) { vehiclesSearchInput.value = q; }
        vehiclesSearch();
    } else if (activeQuickFilter === "mandats") {
        navigateTo("warrants");
        if (warrantsSearchInput) { warrantsSearchInput.value = q; }
        warrantsSearch();
    } else if (activeQuickFilter === "casiers") {
        navigateTo("casiers");
        if (casiersSearchInput) { casiersSearchInput.value = q; }
        fetch("https://" + resourceName + "/searchCasiers", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
    } else if (activeQuickFilter === "rapports") {
        navigateTo("rapports");
        if (rapportsSearchInput) { rapportsSearchInput.value = q; }
        fetch("https://" + resourceName + "/searchReports", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
    }
}

if (quickSearchBtn) quickSearchBtn.addEventListener("click", quickSearchExecute);
if (quickSearchInput) quickSearchInput.addEventListener("keydown", function (e) { if (e.key === "Enter") { e.preventDefault(); quickSearchExecute(); } });

/* ====== ALERTS ====== */
var btnNewAlert = document.getElementById("btnNewAlert");
var alertForm = document.getElementById("alertForm");
var alertReasonInput = document.getElementById("alertReasonInput");
var alertFormCancel = document.getElementById("alertFormCancel");
var alertFormSubmit = document.getElementById("alertFormSubmit");
var dashAlertsList = document.getElementById("dashAlertsList");
var alertsCountLabel = document.getElementById("alertsCountLabel");
var selectedAlertUrgency = "low";
var alertsData = [];

if (alertForm) {
    var urgBtns = alertForm.querySelectorAll(".alert-urgency-btn");
    urgBtns.forEach(function (ub) {
        ub.addEventListener("click", function () {
            urgBtns.forEach(function (b) { b.classList.remove("active"); });
            ub.classList.add("active");
            selectedAlertUrgency = ub.getAttribute("data-level");
        });
    });
}

var alertPresets = document.getElementById("alertPresets");
if (alertPresets) {
    alertPresets.querySelectorAll(".alert-preset-btn").forEach(function (pb) {
        pb.addEventListener("click", function () {
            alertPresets.querySelectorAll(".alert-preset-btn").forEach(function (b) { b.classList.remove("selected"); });
            pb.classList.add("selected");
            if (alertReasonInput) alertReasonInput.value = pb.getAttribute("data-reason");
        });
    });
}

if (btnNewAlert) btnNewAlert.addEventListener("click", function () {
    if (alertForm) alertForm.classList.toggle("hidden");
    if (alertPresets) alertPresets.querySelectorAll(".alert-preset-btn").forEach(function (b) { b.classList.remove("selected"); });
});
if (alertFormCancel) alertFormCancel.addEventListener("click", function () {
    if (alertForm) alertForm.classList.add("hidden");
    if (alertReasonInput) alertReasonInput.value = "";
    if (alertPresets) alertPresets.querySelectorAll(".alert-preset-btn").forEach(function (b) { b.classList.remove("selected"); });
});
if (alertFormSubmit) alertFormSubmit.addEventListener("click", function () {
    var reason = alertReasonInput ? alertReasonInput.value.trim() : "";
    if (!reason) { showToast("Sélectionnez un événement"); return; }
    fetch("https://" + resourceName + "/createAlert", { method: "POST", body: JSON.stringify({ reason: reason, urgency: selectedAlertUrgency }) }).catch(function () {});
    if (alertReasonInput) alertReasonInput.value = "";
    if (alertForm) alertForm.classList.add("hidden");
    if (alertPresets) alertPresets.querySelectorAll(".alert-preset-btn").forEach(function (b) { b.classList.remove("selected"); });
    showToast("Alerte envoyée");
});

function alertsRender(list) {
    alertsData = list || [];
    if (alertsCountLabel) alertsCountLabel.textContent = alertsData.length + " alerte(s)";
    if (document.getElementById("statAlertes")) document.getElementById("statAlertes").textContent = alertsData.length;
    if (!dashAlertsList) return;
    dashAlertsList.innerHTML = "";
    if (alertsData.length === 0) { dashAlertsList.innerHTML = "<li class=\"dash-alerts-empty\">Aucune alerte active</li>"; return; }
    alertsData.forEach(function (a) {
        var li = document.createElement("li");
        var dotColor = a.urgency === "high" ? "red" : (a.urgency === "medium" ? "yellow" : "green");
        var dot = "<span class=\"alert-item-dot alert-dot " + dotColor + "\"></span>";
        var coordsHtml = "";
        if (a.x != null && a.y != null && (a.x !== 0 || a.y !== 0)) {
            coordsHtml = " <span class=\"alert-item-coords\" data-x=\"" + a.x + "\" data-y=\"" + a.y + "\">GPS</span>";
        }
        var timeStr = a.created_at ? formatDate(a.created_at) : "";
        li.innerHTML = dot + "<div class=\"alert-item-body\"><span class=\"alert-item-reason\">" + escapeHtml(a.reason || "") + "</span><span class=\"alert-item-meta\">" + escapeHtml(a.author_name || "") + (timeStr ? " — " + escapeHtml(timeStr) : "") + coordsHtml + "</span></div>";
        var coordsEl = li.querySelector(".alert-item-coords");
        if (coordsEl) {
            coordsEl.addEventListener("click", function () {
                var gx = this.getAttribute("data-x");
                var gy = this.getAttribute("data-y");
                fetch("https://" + resourceName + "/alertGPS", { method: "POST", body: JSON.stringify({ x: parseFloat(gx), y: parseFloat(gy) }) }).catch(function () {});
                showToast("Coordonnées ajoutées au GPS");
            });
        }
        dashAlertsList.appendChild(li);
    });
}

/* ====== PANIC BUTTON ====== */
var panicBtn = document.getElementById("panicBtn");
if (panicBtn) panicBtn.addEventListener("click", function () {
    if (this.dataset.confirm === "1") {
        fetch("https://" + resourceName + "/panicButton", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
        this.dataset.confirm = "";
        this.textContent = "PANIC";
        panicBtn.classList.add("panic-active");
        setTimeout(function () { panicBtn.classList.remove("panic-active"); }, 3000);
        showToast("PANIC envoyé !");
        return;
    }
    this.dataset.confirm = "1";
    this.textContent = "CONFIRMER";
    var self = this;
    setTimeout(function () { self.dataset.confirm = ""; self.textContent = "PANIC"; }, 3000);
});

/* ====== CASIERS PAGE ====== */
var casiersSearchInput = document.getElementById("casiersSearchInput");
var casiersResultsList = document.getElementById("casiersResultsList");
var casiersHint = document.getElementById("casiersHint");
var casiersResultsWrap = document.getElementById("casiersResultsWrap");
var casiersDetailPanel = document.getElementById("casiersDetailPanel");
var casiersDetailContent = document.getElementById("casiersDetailContent");
var btnCasiersDetailBack = document.getElementById("btnCasiersDetailBack");
var casiersCreateForm = document.getElementById("casiersCreateForm");
var btnCasiersCreate = document.getElementById("btnCasiersCreate");
var btnCasiersFormCancel = document.getElementById("btnCasiersFormCancel");
var btnCasiersFormSubmit = document.getElementById("btnCasiersFormSubmit");
var casiersTargetSearch = document.getElementById("casiersTargetSearch");
var casiersTargetSelected = document.getElementById("casiersTargetSelected");
var casiersTargetResults = document.getElementById("casiersTargetResults");
var btnCasiersTargetClear = document.getElementById("btnCasiersTargetClear");
var casiersFormType = document.getElementById("casiersFormType");
var casiersFormDescription = document.getElementById("casiersFormDescription");
var casiersFormSanction = document.getElementById("casiersFormSanction");
var casiersFormAmende = document.getElementById("casiersFormAmende");
var casiersFormPhotosGrid = document.getElementById("casiersFormPhotosGrid");
var btnCasiersAddFromGallery = document.getElementById("btnCasiersAddFromGallery");
var casiersFormPhotos = [];
var casiersPinnedSection = document.getElementById("casiersPinnedSection");
var casiersPinnedList = document.getElementById("casiersPinnedList");
var casiersSelectedTarget = null;
var casiersTargetSearchDebounce = null;
var casiersTargetSearching = false;
var CASIER_PIN_KEY = "SNL_PolTablet-pinned-casiers";
var pendingSubpageSection = null;

function casiersPhotosRender() {
    if (!casiersFormPhotosGrid) return;
    casiersFormPhotosGrid.innerHTML = "";
    casiersFormPhotos.forEach(function (url, idx) {
        var thumb = document.createElement("div");
        thumb.className = "casier-photo-thumb";
        var img = document.createElement("img"); img.src = url; img.alt = "";
        var del = document.createElement("button"); del.type = "button"; del.className = "casier-photo-remove"; del.textContent = "\u00d7"; del.title = "Retirer";
        del.addEventListener("click", function () { casiersFormPhotos.splice(idx, 1); casiersPhotosRender(); });
        thumb.appendChild(img); thumb.appendChild(del);
        casiersFormPhotosGrid.appendChild(thumb);
    });
}

function openGalleryPickerForCasiers() {
    if (!galleryPickerModal || !galleryPickerGrid || !galleryPickerHint) return;
    var g = photoGetGallery();
    galleryPickerHint.classList.toggle("hidden", g.length > 0);
    galleryPickerGrid.innerHTML = "";
    g.forEach(function (url) {
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "photo-pick-item";
        if (casiersFormPhotos.indexOf(url) >= 0) btn.classList.add("selected");
        var img = document.createElement("img"); img.src = url; img.alt = "";
        btn.appendChild(img);
        btn.addEventListener("click", function () {
            if (casiersFormPhotos.indexOf(url) === -1) {
                casiersFormPhotos.push(url);
                btn.classList.add("selected");
            }
            casiersPhotosRender();
            galleryPickerModal.classList.add("hidden");
        });
        galleryPickerGrid.appendChild(btn);
    });
    galleryPickerModal.classList.remove("hidden");
}

function getCasierPins() { try { return JSON.parse(localStorage.getItem(CASIER_PIN_KEY)) || []; } catch (e) { return []; } }
function saveCasierPins(arr) { try { localStorage.setItem(CASIER_PIN_KEY, JSON.stringify(arr)); } catch (e) {} }
function toggleCasierPin(id) { var pins = getCasierPins(); var idx = pins.indexOf(id); if (idx >= 0) pins.splice(idx, 1); else pins.push(id); saveCasierPins(pins); return pins.indexOf(id) >= 0; }
function isCasierPinned(id) { return getCasierPins().indexOf(id) >= 0; }

var casiersLastList = null, casiersLastAt = 0;

function casiersLoadRecent(force) {
    if (!force && casiersLastList && (Date.now() - casiersLastAt) < LIST_REFETCH_MS) {
        casiersRenderList(casiersLastList);
        return;
    }
    fetch("https://" + resourceName + "/getRecentCasiers", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
}

function casiersFormReset() {
    casiersSelectedTarget = null;
    if (casiersTargetSelected) { casiersTargetSelected.textContent = ""; casiersTargetSelected.classList.add("hidden"); }
    if (casiersTargetResults) { casiersTargetResults.innerHTML = ""; casiersTargetResults.classList.add("hidden"); }
    if (casiersTargetSearch) { casiersTargetSearch.value = ""; casiersTargetSearch.disabled = false; }
    if (casiersFormType) casiersFormType.value = "";
    if (casiersFormDescription) casiersFormDescription.value = "";
    if (casiersFormSanction) casiersFormSanction.value = "";
    if (casiersFormAmende) casiersFormAmende.value = "";
    casiersFormPhotos = [];
    if (casiersFormPhotosGrid) casiersFormPhotosGrid.innerHTML = "";
    if (casiersCreateForm) casiersCreateForm._editId = null;
}

function casiersOpenCreateWithTarget(target) {
    casiersFormReset();
    casiersSelectedTarget = target;
    var name = formatName(target.firstname, target.lastname);
    if (casiersTargetSelected) { casiersTargetSelected.textContent = name + " \u2014 " + (target.identifier || ""); casiersTargetSelected.classList.remove("hidden"); }
    if (casiersCreateForm) casiersCreateForm.classList.remove("hidden");
    if (casiersResultsWrap) casiersResultsWrap.classList.add("hidden");
}

function casiersShowDetail(c) {
    if (!casiersDetailContent || !casiersDetailPanel) return;
    var name = (c.firstname || c.lastname) ? formatName(c.firstname, c.lastname) : (c.identifier || "\u2014");
    var card = "<div class=\"detail-card\"><div class=\"detail-header\"><div class=\"detail-icon blue\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z\"/></svg></div><div class=\"detail-title\"><h3>Casier #" + escapeHtml(String(c.id || "")) + "</h3><p>" + escapeHtml(name) + "</p></div></div><div class=\"detail-body\">";
    if (c.infraction_type) card += "<div class=\"detail-field\"><span class=\"detail-label\">Type d'infraction</span><div class=\"detail-value\">" + escapeHtml(c.infraction_type) + "</div></div>";
    var desc = c.entry || "";
    if (desc) card += "<div class=\"detail-field\"><span class=\"detail-label\">Description</span><div class=\"detail-value\">" + escapeHtml(desc) + "</div></div>";
    if (c.sanction) card += "<div class=\"detail-field\"><span class=\"detail-label\">Peine / Sanction</span><div class=\"detail-value\">" + escapeHtml(c.sanction) + "</div></div>";
    if (c.amende && c.amende > 0) card += "<div class=\"detail-field\"><span class=\"detail-label\">Amende</span><div class=\"detail-value amende\">$" + Number(c.amende).toLocaleString() + "</div></div>";
    if (c.added_by) card += "<div class=\"detail-field\"><span class=\"detail-label\">Ajouté par</span><div class=\"detail-value\">" + escapeHtml(c.added_by) + "</div></div>";
    if (c.created_at) card += "<div class=\"detail-field\"><span class=\"detail-label\">Date</span><div class=\"detail-value\">" + escapeHtml(formatDate(c.created_at)) + "</div></div>";
    var imgs = [];
    if (c.images) {
        if (Array.isArray(c.images)) { imgs = c.images; }
        else if (typeof c.images === "string") { try { var parsed = JSON.parse(c.images); if (Array.isArray(parsed)) imgs = parsed; } catch (e) {} }
    }
    if (imgs.length > 0) {
        card += "<div class=\"detail-field\"><span class=\"detail-label\">Photos / Preuves</span><div class=\"detail-images\">";
        imgs.forEach(function (u) { card += "<img src=\"" + escapeHtml(u) + "\" alt=\"Preuve\" style=\"cursor:pointer\" onclick=\"openLightbox(this.src)\" onerror=\"this.style.display='none'\" />"; });
        card += "</div></div>";
    }
    card += "</div>";
    card += "<div class=\"detail-actions\">";
    if (playerGradeLevel >= 8) card += "<button type=\"button\" class=\"mdt-btn mdt-btn-accent\" id=\"editCasierBtn\">Modifier</button>";
    card += "<button type=\"button\" class=\"mdt-btn mdt-btn-danger\" id=\"deleteCasierBtn\">Supprimer le casier</button></div>";
    card += "</div>";
    casiersDetailContent.innerHTML = card;
    var editCasierBtn = document.getElementById("editCasierBtn");
    if (editCasierBtn) {
        editCasierBtn.addEventListener("click", function () {
            casiersFormReset();
            casiersSelectedTarget = { identifier: c.identifier, firstname: c.firstname, lastname: c.lastname };
            var name = (c.firstname || c.lastname) ? formatName(c.firstname, c.lastname) : (c.identifier || "");
            if (casiersTargetSelected) { casiersTargetSelected.textContent = name + " \u2014 " + (c.identifier || ""); casiersTargetSelected.classList.remove("hidden"); }
            if (casiersTargetSearch) casiersTargetSearch.disabled = true;
            if (casiersFormType) casiersFormType.value = c.infraction_type || "";
            if (casiersFormDescription) casiersFormDescription.value = c.entry || "";
            if (casiersFormSanction) casiersFormSanction.value = c.sanction || "";
            if (casiersFormAmende) casiersFormAmende.value = (c.amende && c.amende > 0) ? c.amende : "";
            casiersFormPhotos = imgs.slice();
            casiersPhotosRender();
            if (casiersCreateForm) casiersCreateForm.classList.remove("hidden");
            if (casiersDetailPanel) casiersDetailPanel.classList.add("hidden");
            casiersCreateForm._editId = c.id;
        });
    }
    var delCasierBtn = document.getElementById("deleteCasierBtn");
    if (delCasierBtn) {
        delCasierBtn.addEventListener("click", function () {
            if (deleteLimitReached()) { showToast("Limite de suppressions atteinte (" + SESSION_DELETE_MAX + "/session)"); return; }
            if (this.dataset.confirm === "1") {
                fetch("https://" + resourceName + "/deleteCasier", { method: "POST", body: JSON.stringify({ id: c.id }) }).catch(function () {});
                return;
            }
            this.dataset.confirm = "1";
            this.textContent = "Confirmer ?";
            var self = this;
            setTimeout(function () { self.dataset.confirm = ""; self.textContent = "Supprimer le casier"; }, 3000);
        });
    }
    casiersResultsWrap.classList.add("hidden");
    if (casiersCreateForm) casiersCreateForm.classList.add("hidden");
    casiersDetailPanel.classList.remove("hidden");
}

function casiersRenderList(list) {
    if (!casiersResultsList) return;
    casiersResultsList.innerHTML = "";
    if (casiersHint) casiersHint.classList.add("hidden");
    var statCasiersEl = document.getElementById("statCasiers");
    if (statCasiersEl && list) statCasiersEl.textContent = list.length;
    if (!list || list.length === 0) { if (casiersHint) { casiersHint.textContent = "Aucun casier trouvé."; casiersHint.classList.remove("hidden"); } return; }
    var pins = getCasierPins();
    var pinned = []; var unpinned = [];
    list.forEach(function (c) { if (pins.indexOf(c.id) >= 0) pinned.push(c); else unpinned.push(c); });
    if (casiersPinnedSection && casiersPinnedList) {
        casiersPinnedList.innerHTML = "";
        if (pinned.length > 0) {
            casiersPinnedSection.classList.remove("hidden");
            pinned.forEach(function (c) { casiersPinnedList.appendChild(casiersCreateListItem(c, true)); });
        } else { casiersPinnedSection.classList.add("hidden"); }
    }
    unpinned.forEach(function (c) { casiersResultsList.appendChild(casiersCreateListItem(c, false)); });
}

function casiersCreateListItem(c, isPinned) {
    var li = document.createElement("li");
    var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item";
    var name = (c.firstname || c.lastname) ? formatName(c.firstname, c.lastname) : (c.identifier || "\u2014");
    var typeStr = c.infraction_type ? escapeHtml(c.infraction_type) : (c.entry ? escapeHtml(c.entry.substring(0, 40)) : "");
    btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z\"/></svg></span><div class=\"result-meta\"><span class=\"result-label\">" + escapeHtml(name) + "</span><span class=\"result-sub\">" + typeStr + "</span></div><span class=\"result-chevron\"></span>";
    btn.addEventListener("click", function () { casiersShowDetail(c); });
    li.appendChild(btn);
    var pinBtn = document.createElement("button"); pinBtn.type = "button"; pinBtn.className = "result-pin-btn" + (isPinned ? " pinned" : "");
    pinBtn.title = isPinned ? "Désépingler" : "Épingler";
    pinBtn.innerHTML = "<svg viewBox=\"0 0 24 24\" fill=\"" + (isPinned ? "currentColor" : "none") + "\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z\"/></svg>";
    pinBtn.addEventListener("click", function (e) { e.stopPropagation(); toggleCasierPin(c.id); casiersLoadRecent(); });
    li.style.display = "flex"; li.style.alignItems = "center"; li.style.gap = "4px";
    li.appendChild(pinBtn);
    return li;
}

if (casiersSearchInput) {
    casiersSearchInput.addEventListener("input", function () {
        if (this._debounce) clearTimeout(this._debounce);
        var self = this;
        this._debounce = setTimeout(function () {
            var q = self.value.trim();
            if (q.length < 4) { casiersLoadRecent(); return; }
            fetch("https://" + resourceName + "/searchCasiers", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
        }, 500);
    });
}
if (btnCasiersCreate) btnCasiersCreate.addEventListener("click", function () { casiersFormReset(); if (casiersDetailPanel) casiersDetailPanel.classList.add("hidden"); if (casiersCreateForm) casiersCreateForm.classList.remove("hidden"); if (casiersResultsWrap) casiersResultsWrap.classList.add("hidden"); });
if (btnCasiersFormCancel) btnCasiersFormCancel.addEventListener("click", function () { if (casiersCreateForm) casiersCreateForm.classList.add("hidden"); if (casiersResultsWrap) casiersResultsWrap.classList.remove("hidden"); });
if (btnCasiersDetailBack) btnCasiersDetailBack.addEventListener("click", function () { if (casiersDetailPanel) casiersDetailPanel.classList.add("hidden"); if (casiersResultsWrap) casiersResultsWrap.classList.remove("hidden"); });
if (btnCasiersTargetClear) btnCasiersTargetClear.addEventListener("click", function () { casiersSelectedTarget = null; if (casiersTargetSelected) { casiersTargetSelected.textContent = ""; casiersTargetSelected.classList.add("hidden"); } if (casiersTargetSearch) casiersTargetSearch.value = ""; if (casiersTargetResults) casiersTargetResults.classList.add("hidden"); });
if (casiersTargetSearch) casiersTargetSearch.addEventListener("input", function () {
    clearTimeout(casiersTargetSearchDebounce);
    var q = this.value.trim();
    if (q.length < 4) { if (casiersTargetResults) { casiersTargetResults.innerHTML = ""; casiersTargetResults.classList.add("hidden"); } return; }
    casiersTargetSearchDebounce = setTimeout(function () {
        casiersTargetSearching = true;
        fetch("https://" + resourceName + "/searchCitizens", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
    }, 500);
});
if (btnCasiersFormSubmit) btnCasiersFormSubmit.addEventListener("click", function () {
    if (!casiersSelectedTarget || !casiersSelectedTarget.identifier) return;
    var entry = (casiersFormDescription && casiersFormDescription.value) ? casiersFormDescription.value.trim() : "";
    var infraction_type = (casiersFormType && casiersFormType.value) ? casiersFormType.value.trim() : "";
    var sanction = (casiersFormSanction && casiersFormSanction.value) ? casiersFormSanction.value.trim() : "";
    var amende = (casiersFormAmende && casiersFormAmende.value) ? parseFloat(casiersFormAmende.value) || 0 : 0;
    var images = casiersFormPhotos.slice();
    var editId = casiersCreateForm && casiersCreateForm._editId;
    if (editId) {
        fetch("https://" + resourceName + "/editCasier", { method: "POST", body: JSON.stringify({ id: editId, entry: entry, infraction_type: infraction_type, sanction: sanction, amende: amende, images: images }) }).catch(function () {});
    } else {
        fetch("https://" + resourceName + "/createFullCasier", { method: "POST", body: JSON.stringify({ identifier: casiersSelectedTarget.identifier, entry: entry, infraction_type: infraction_type, sanction: sanction, amende: amende, images: images }) }).catch(function () {});
    }
});

/* ====== RAPPORTS PAGE ====== */
var rapportsSearchInput = document.getElementById("rapportsSearchInput");
var rapportsResultsList = document.getElementById("rapportsResultsList");
var rapportsHint = document.getElementById("rapportsHint");
var rapportsResultsWrap = document.getElementById("rapportsResultsWrap");
var rapportsDetailPanel = document.getElementById("rapportsDetailPanel");
var rapportsDetailContent = document.getElementById("rapportsDetailContent");
var btnRapportsDetailBack = document.getElementById("btnRapportsDetailBack");
var rapportsCreateForm = document.getElementById("rapportsCreateForm");
var rapportsFormTitle = document.getElementById("rapportsFormTitle");
var btnRapportsCreate = document.getElementById("btnRapportsCreate");
var btnRapportsFormCancel = document.getElementById("btnRapportsFormCancel");
var btnRapportsFormSubmit = document.getElementById("btnRapportsFormSubmit");
var rapportsTargetSearch = document.getElementById("rapportsTargetSearch");
var rapportsTargetSelected = document.getElementById("rapportsTargetSelected");
var rapportsTargetResults = document.getElementById("rapportsTargetResults");
var btnRapportsTargetClear = document.getElementById("btnRapportsTargetClear");
var rapportsFormTitleInput = document.getElementById("rapportsFormTitleInput");
var rapportsFormContent = document.getElementById("rapportsFormContent");
var rapportsFormImages = document.getElementById("rapportsFormImages");
var rapportsSelectedTarget = null;
var rapportsTargetSearchDebounce = null;
var rapportsTargetSearching = false;
var rapportsEditingId = null;

function rapportsLoadRecent() {
    fetch("https://" + resourceName + "/getRecentReports", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
}

function rapportsFormReset() {
    rapportsSelectedTarget = null;
    rapportsEditingId = null;
    if (rapportsTargetSelected) { rapportsTargetSelected.textContent = ""; rapportsTargetSelected.classList.add("hidden"); }
    if (rapportsTargetResults) { rapportsTargetResults.innerHTML = ""; rapportsTargetResults.classList.add("hidden"); }
    if (rapportsTargetSearch) rapportsTargetSearch.value = "";
    if (rapportsFormTitleInput) rapportsFormTitleInput.value = "";
    if (rapportsFormContent) rapportsFormContent.value = "";
    if (rapportsFormImages) rapportsFormImages.value = "";
    if (rapportsFormTitle) rapportsFormTitle.textContent = "Nouveau rapport";
    if (btnRapportsFormSubmit) btnRapportsFormSubmit.textContent = "Créer le rapport";
}

function rapportsOpenCreateWithTarget(target) {
    rapportsFormReset();
    rapportsSelectedTarget = target;
    var name = formatName(target.firstname, target.lastname);
    if (rapportsTargetSelected) { rapportsTargetSelected.textContent = name + " \u2014 " + (target.identifier || ""); rapportsTargetSelected.classList.remove("hidden"); }
    if (rapportsCreateForm) rapportsCreateForm.classList.remove("hidden");
    if (rapportsResultsWrap) rapportsResultsWrap.classList.add("hidden");
}

function rapportsOpenEdit(r) {
    rapportsFormReset();
    rapportsEditingId = r.id;
    rapportsSelectedTarget = { identifier: r.identifier, firstname: r.firstname, lastname: r.lastname };
    var name = formatName(r.firstname, r.lastname);
    if (rapportsTargetSelected) { rapportsTargetSelected.textContent = name + " \u2014 " + (r.identifier || ""); rapportsTargetSelected.classList.remove("hidden"); }
    if (rapportsFormTitleInput) rapportsFormTitleInput.value = r.title || "";
    if (rapportsFormContent) rapportsFormContent.value = r.content || "";
    if (rapportsFormImages) {
        var imgs = [];
        if (r.images) { try { var p = typeof r.images === "string" ? JSON.parse(r.images) : r.images; if (Array.isArray(p)) imgs = p; } catch (e) {} }
        rapportsFormImages.value = imgs.join("\n");
    }
    if (rapportsFormTitle) rapportsFormTitle.textContent = "Modifier le rapport #" + r.id;
    if (btnRapportsFormSubmit) btnRapportsFormSubmit.textContent = "Enregistrer";
    if (rapportsCreateForm) rapportsCreateForm.classList.remove("hidden");
    if (rapportsResultsWrap) rapportsResultsWrap.classList.add("hidden");
    if (rapportsDetailPanel) rapportsDetailPanel.classList.add("hidden");
}

function rapportsShowDetail(r) {
    if (!rapportsDetailContent || !rapportsDetailPanel) return;
    var name = (r.firstname || r.lastname) ? formatName(r.firstname, r.lastname) : (r.identifier || "\u2014");
    var html = "<div class=\"detail-card\"><div class=\"detail-header\"><div class=\"detail-icon green\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 20h9\"/><path d=\"M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z\"/></svg></div><div class=\"detail-title\"><h3>" + escapeHtml(r.title || "Rapport #" + (r.id || "")) + "</h3><p>" + escapeHtml(name) + "</p></div></div><div class=\"detail-body\">";
    if (r.content) html += "<div class=\"detail-field\"><span class=\"detail-label\">Contenu</span><div class=\"detail-value\">" + escapeHtml(r.content) + "</div></div>";
    if (r.author_identifier) html += "<div class=\"detail-field\"><span class=\"detail-label\">Auteur</span><div class=\"detail-value\">" + escapeHtml(r.author_identifier) + "</div></div>";
    if (r.created_at) html += "<div class=\"detail-field\"><span class=\"detail-label\">Date</span><div class=\"detail-value\">" + escapeHtml(formatDate(r.created_at)) + "</div></div>";
    var images = [];
    if (r.images) { try { var p = typeof r.images === "string" ? JSON.parse(r.images) : r.images; if (Array.isArray(p)) images = p.filter(function (u) { return u && u.trim(); }); } catch (e) {} }
    if (images.length > 0) {
        html += "<div class=\"detail-field\"><span class=\"detail-label\">Images</span><div class=\"detail-images\">";
        images.forEach(function (u) { html += "<img src=\"" + escapeHtml(u) + "\" alt=\"Evidence\" onerror=\"this.style.display='none'\" onclick=\"openLightbox(this.src)\" style=\"cursor:pointer\">"; });
        html += "</div></div>";
    }
    html += "</div><div class=\"detail-actions\"><button type=\"button\" class=\"mdt-btn mdt-btn-primary\" id=\"rapportEditDetailBtn\">Modifier</button>";
    html += "<button type=\"button\" class=\"mdt-btn mdt-btn-danger\" id=\"deleteReportBtn\">Supprimer</button>";
    html += "</div></div>";
    rapportsDetailContent.innerHTML = html;
    var editDetailBtn = document.getElementById("rapportEditDetailBtn");
    if (editDetailBtn) editDetailBtn.addEventListener("click", function () { rapportsOpenEdit(r); });
    var delReportBtn = document.getElementById("deleteReportBtn");
    if (delReportBtn) {
        delReportBtn.addEventListener("click", function () {
            if (deleteLimitReached()) { showToast("Limite de suppressions atteinte (" + SESSION_DELETE_MAX + "/session)"); return; }
            if (this.dataset.confirm === "1") {
                fetch("https://" + resourceName + "/deleteReport", { method: "POST", body: JSON.stringify({ id: r.id }) }).catch(function () {});
                return;
            }
            this.dataset.confirm = "1";
            this.textContent = "Confirmer ?";
            var self = this;
            setTimeout(function () { self.dataset.confirm = ""; self.textContent = "Supprimer"; }, 3000);
        });
    }
    rapportsResultsWrap.classList.add("hidden");
    if (rapportsCreateForm) rapportsCreateForm.classList.add("hidden");
    rapportsDetailPanel.classList.remove("hidden");
}

function rapportsRenderList(list) {
    if (!rapportsResultsList) return;
    rapportsResultsList.innerHTML = "";
    if (rapportsHint) rapportsHint.classList.add("hidden");
    if (!list || list.length === 0) { if (rapportsHint) { rapportsHint.textContent = "Aucun rapport trouvé."; rapportsHint.classList.remove("hidden"); } return; }
    list.forEach(function (r) {
        var li = document.createElement("li");
        li.style.display = "flex"; li.style.alignItems = "center"; li.style.gap = "4px";
        var btn = document.createElement("button"); btn.type = "button"; btn.className = "result-item"; btn.style.flex = "1";
        var name = (r.firstname || r.lastname) ? formatName(r.firstname, r.lastname) : (r.identifier || "\u2014");
        var titleStr = r.title ? escapeHtml(r.title) : escapeHtml((r.content || "").substring(0, 40));
        btn.innerHTML = "<span class=\"result-icon\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 20h9\"/><path d=\"M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z\"/></svg></span><div class=\"result-meta\"><span class=\"result-label\">" + escapeHtml(name) + "</span><span class=\"result-sub\">" + titleStr + "</span></div><span class=\"result-chevron\"></span>";
        btn.addEventListener("click", function () { rapportsShowDetail(r); });
        li.appendChild(btn);
        var editBtn = document.createElement("button"); editBtn.type = "button"; editBtn.className = "result-action-btn";
        editBtn.textContent = "Éditer";
        editBtn.addEventListener("click", function (e) { e.stopPropagation(); rapportsOpenEdit(r); });
        li.appendChild(editBtn);
        rapportsResultsList.appendChild(li);
    });
}

if (rapportsSearchInput) {
    rapportsSearchInput.addEventListener("input", function () {
        if (this._debounce) clearTimeout(this._debounce);
        var self = this;
        this._debounce = setTimeout(function () {
            var q = self.value.trim();
            if (q.length < 4) { rapportsLoadRecent(); return; }
            fetch("https://" + resourceName + "/searchReports", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
        }, 500);
    });
}
if (btnRapportsCreate) btnRapportsCreate.addEventListener("click", function () { rapportsFormReset(); if (rapportsDetailPanel) rapportsDetailPanel.classList.add("hidden"); if (rapportsCreateForm) rapportsCreateForm.classList.remove("hidden"); if (rapportsResultsWrap) rapportsResultsWrap.classList.add("hidden"); });
if (btnRapportsFormCancel) btnRapportsFormCancel.addEventListener("click", function () { if (rapportsCreateForm) rapportsCreateForm.classList.add("hidden"); if (rapportsResultsWrap) rapportsResultsWrap.classList.remove("hidden"); });
if (btnRapportsDetailBack) btnRapportsDetailBack.addEventListener("click", function () { if (rapportsDetailPanel) rapportsDetailPanel.classList.add("hidden"); if (rapportsResultsWrap) rapportsResultsWrap.classList.remove("hidden"); });
if (btnRapportsTargetClear) btnRapportsTargetClear.addEventListener("click", function () { rapportsSelectedTarget = null; if (rapportsTargetSelected) { rapportsTargetSelected.textContent = ""; rapportsTargetSelected.classList.add("hidden"); } if (rapportsTargetSearch) rapportsTargetSearch.value = ""; if (rapportsTargetResults) rapportsTargetResults.classList.add("hidden"); });
if (rapportsTargetSearch) rapportsTargetSearch.addEventListener("input", function () {
    clearTimeout(rapportsTargetSearchDebounce);
    var q = this.value.trim();
    if (q.length < 4) { if (rapportsTargetResults) { rapportsTargetResults.innerHTML = ""; rapportsTargetResults.classList.add("hidden"); } return; }
    rapportsTargetSearchDebounce = setTimeout(function () {
        rapportsTargetSearching = true;
        fetch("https://" + resourceName + "/searchCitizens", { method: "POST", body: JSON.stringify({ query: q }) }).catch(function () {});
    }, 500);
});
if (btnRapportsFormSubmit) btnRapportsFormSubmit.addEventListener("click", function () {
    if (!rapportsSelectedTarget || !rapportsSelectedTarget.identifier) return;
    var title = (rapportsFormTitleInput && rapportsFormTitleInput.value) ? rapportsFormTitleInput.value.trim() : "";
    var content = (rapportsFormContent && rapportsFormContent.value) ? rapportsFormContent.value.trim() : "";
    var imagesRaw = (rapportsFormImages && rapportsFormImages.value) ? rapportsFormImages.value.trim() : "";
    var imagesArr = imagesRaw ? imagesRaw.split(/\r?\n/).map(function (s) { return s.trim(); }).filter(Boolean) : [];
    if (rapportsEditingId) {
        fetch("https://" + resourceName + "/editReport", { method: "POST", body: JSON.stringify({ id: rapportsEditingId, title: title, content: content, images: imagesArr.length ? JSON.stringify(imagesArr) : "[]" }) }).catch(function () {});
    } else {
        fetch("https://" + resourceName + "/createFullReport", { method: "POST", body: JSON.stringify({ identifier: rapportsSelectedTarget.identifier, title: title, content: content, images: imagesArr.length ? JSON.stringify(imagesArr) : "[]" }) }).catch(function () {});
    }
});

/* ====== PHOTO PAGE ====== */
var STORAGE_PHOTO_GALLERY = "SNL_PolTablet-photo-gallery";
var btnTakePhoto = document.getElementById("btnTakePhoto");
var photoGallery = document.getElementById("photoGallery");
var photoGalleryHint = document.getElementById("photoGalleryHint");
var galleryPickerModal = document.getElementById("galleryPickerModal");
var galleryPickerGrid = document.getElementById("galleryPickerGrid");
var galleryPickerHint = document.getElementById("galleryPickerHint");
var galleryPickerCancel = document.getElementById("galleryPickerCancel");
var btnWarrantsAddFromGallery = document.getElementById("btnWarrantsAddFromGallery");
var btnRapportsAddFromGallery = document.getElementById("btnRapportsAddFromGallery");

function photoGetGallery() {
    try {
        var raw = localStorage.getItem(STORAGE_PHOTO_GALLERY);
        if (!raw) return [];
        var arr = JSON.parse(raw);
        return Array.isArray(arr) ? arr.filter(function (u) { return u && typeof u === "string" && u.trim(); }) : [];
    } catch (e) { return []; }
}
function photoSaveGallery(arr) {
    try { localStorage.setItem(STORAGE_PHOTO_GALLERY, JSON.stringify(arr)); } catch (e) {}
}
function photoAddToGallery(url) {
    var g = photoGetGallery();
    if (g.indexOf(url) === -1) g.unshift(url);
    photoSaveGallery(g);
    photoRenderGallery();
}
function photoRemoveFromGallery(url) {
    var g = photoGetGallery().filter(function (u) { return u !== url; });
    photoSaveGallery(g);
    photoRenderGallery();
}

function photoRenderGallery() {
    if (!photoGallery || !photoGalleryHint) return;
    var g = photoGetGallery();
    photoGalleryHint.classList.toggle("hidden", g.length > 0);
    photoGallery.innerHTML = "";
    g.forEach(function (url) {
        var wrap = document.createElement("div");
        wrap.className = "photo-gallery-item";
        var img = document.createElement("img");
        img.src = url;
        img.alt = "";
        img.onerror = function () { wrap.style.display = "none"; };
        img.addEventListener("click", function () { openLightbox(url); });
        var del = document.createElement("button");
        del.type = "button";
        del.className = "photo-delete";
        del.textContent = "\u00d7";
        del.title = "Supprimer";
        del.addEventListener("click", function (e) { e.stopPropagation(); photoRemoveFromGallery(url); });
        wrap.appendChild(img);
        wrap.appendChild(del);
        photoGallery.appendChild(wrap);
    });
}

function openGalleryPickerFor(targetTextarea) {
    if (!galleryPickerModal || !galleryPickerGrid || !galleryPickerHint) return;
    galleryPickerModal._targetTextarea = targetTextarea;
    var g = photoGetGallery();
    galleryPickerHint.classList.toggle("hidden", g.length > 0);
    galleryPickerGrid.innerHTML = "";
    g.forEach(function (url) {
        var btn = document.createElement("button");
        btn.type = "button";
        btn.className = "photo-pick-item";
        var img = document.createElement("img");
        img.src = url;
        img.alt = "";
        btn.appendChild(img);
        btn.addEventListener("click", function () {
            var ta = galleryPickerModal._targetTextarea;
            if (ta) {
                var cur = (ta.value || "").trim();
                var lines = cur ? cur.split(/\r?\n/).map(function (s) { return s.trim(); }).filter(Boolean) : [];
                if (lines.indexOf(url) === -1) lines.push(url);
                ta.value = lines.join("\n");
            }
            galleryPickerModal.classList.add("hidden");
        });
        galleryPickerGrid.appendChild(btn);
    });
    galleryPickerModal.classList.remove("hidden");
}

if (btnTakePhoto) btnTakePhoto.addEventListener("click", function () {
    playUiSound();
    if (this.disabled) return;
    this.disabled = true;
    fetch("https://" + resourceName + "/startPhotoMode", { method: "POST", body: JSON.stringify({}) }).catch(function () {
        btnTakePhoto.disabled = false;
    });
});

if (galleryPickerCancel) galleryPickerCancel.addEventListener("click", function () { if (galleryPickerModal) galleryPickerModal.classList.add("hidden"); });
if (galleryPickerModal) galleryPickerModal.addEventListener("click", function (e) { if (e.target === galleryPickerModal) galleryPickerModal.classList.add("hidden"); });

if (btnWarrantsAddFromGallery) btnWarrantsAddFromGallery.addEventListener("click", function () { openGalleryPickerForWarrants(); });
if (btnRapportsAddFromGallery) btnRapportsAddFromGallery.addEventListener("click", function () { openGalleryPickerFor(rapportsFormImages); });
if (btnCasiersAddFromGallery) btnCasiersAddFromGallery.addEventListener("click", function () { openGalleryPickerForCasiers(); });

/* ====== SETTINGS ====== */
var profileImageUrl = document.getElementById("profileImageUrl");
var profileImageFeedback = document.getElementById("profileImageFeedback");
var btnSaveProfileImage = document.getElementById("btnSaveProfileImage");
var btnClearProfileImage = document.getElementById("btnClearProfileImage");

function showProfileFeedback(msg, type) {
    if (!profileImageFeedback) return;
    profileImageFeedback.textContent = msg;
    profileImageFeedback.classList.remove("hidden", "success", "error");
    if (type === "success" || type === "error") profileImageFeedback.classList.add(type);
    else profileImageFeedback.classList.add("hidden");
}

if (btnSaveProfileImage) btnSaveProfileImage.addEventListener("click", function () {
    var url = profileImageUrl ? profileImageUrl.value.trim() : "";
    showProfileFeedback("", "hidden");
    fetch("https://" + resourceName + "/setProfileImage", { method: "POST", body: JSON.stringify({ url: url }), headers: { "Content-Type": "application/json" } }).catch(function () { showProfileFeedback("Erreur.", "error"); });
});
if (btnClearProfileImage) btnClearProfileImage.addEventListener("click", function () {
    if (profileImageUrl) profileImageUrl.value = "";
    fetch("https://" + resourceName + "/setProfileImage", { method: "POST", body: JSON.stringify({ url: "" }), headers: { "Content-Type": "application/json" } }).catch(function () {});
});
function applyTheme() {
    var t = getTheme();
    var screenEl = document.querySelector(".screen");
    if (screenEl) {
        screenEl.classList.remove("theme-navy", "theme-light");
        if (t === "navy") screenEl.classList.add("theme-navy");
        if (t === "light") screenEl.classList.add("theme-light");
    }
    ["btnThemeDark", "btnThemeNavy", "btnThemeLight"].forEach(function (id, i) {
        var btn = document.getElementById(id);
        if (btn) btn.classList.toggle("theme-active", (["dark", "navy", "light"][i]) === t);
    });
}
function initThemeButtons() {
    var btns = [document.getElementById("btnThemeDark"), document.getElementById("btnThemeNavy"), document.getElementById("btnThemeLight")];
    var themes = ["dark", "navy", "light"];
    btns.forEach(function (btn, i) {
        if (btn) btn.addEventListener("click", function () { setTheme(themes[i]); applyTheme(); });
    });
}
initThemeButtons();

function applySoundSettings() {
    var toggle = document.getElementById("soundToggle");
    var select = document.getElementById("soundPackSelect");
    var wrap = document.getElementById("soundPackWrap");
    if (toggle) toggle.checked = getSoundEnabled();
    if (select) select.value = getSoundPack();
    if (wrap) wrap.classList.toggle("sound-disabled", !getSoundEnabled());
    if (select) select.disabled = !getSoundEnabled();
}
function initSoundSettings() {
    var toggle = document.getElementById("soundToggle");
    var select = document.getElementById("soundPackSelect");
    if (toggle) toggle.addEventListener("change", function () {
        setSoundEnabled(this.checked);
        applySoundSettings();
        if (this.checked && getSoundPack() !== "off") playUiSound();
    });
    if (select) select.addEventListener("change", function () {
        setSoundPack(this.value);
        if (this.value !== "off") playUiSound();
    });
}
initSoundSettings();

/* ====== NUI MESSAGE HANDLER ====== */
window.addEventListener("message", function (event) {
    var data = event.data;
    if (data.action === "open") {
        if (data.mapBounds) mapBounds = data.mapBounds;
        if (data.mapImageSize) mapImageSize = data.mapImageSize;
        if (data.mapControlPoints) mapControlPoints = data.mapControlPoints;
        mapCalib = computeCalibration(mapControlPoints, mapImageSize);
        if (data.mapYFlipped !== undefined) mapYFlipped = !!data.mapYFlipped;
        if (data.mapLinear !== undefined) mapLinear = !!data.mapLinear;
        if (data.mapSwapXY !== undefined) mapSwapXY = !!data.mapSwapXY;
        setColors(data.frameColor, data.backgroundColor);
        if (data.player) {
            updatePlayerCard(data.player);
            if (profileImageUrl) profileImageUrl.value = data.player.mugshot || "";
            playerGradeLevel = (data.player.grade_level != null) ? Number(data.player.grade_level) : 0;
            sessionDeleteUnlimited = data.player.delete_unlimited === true;
        }
        updateDutyButton(data.onDuty === true);
        openUI(data);
        fetch("https://" + resourceName + "/getAlerts", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
        fetch("https://" + resourceName + "/getActiveWarrants", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
        fetch("https://" + resourceName + "/getRecentCasiers", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
    } else if (data.action === "updateMugshot" && data.mugshot) {
        if (!hasCustomMugshot) {
            var mugshotEl = document.getElementById("playerMugshot");
            var initialsEl = document.getElementById("playerInitials");
            if (mugshotEl && initialsEl) {
                var img = mugshotEl.querySelector("img");
                if (!img) { img = document.createElement("img"); img.alt = ""; mugshotEl.appendChild(img); }
                img.src = data.mugshot; initialsEl.style.display = "none";
            }
        }
    } else if (data.action === "profileImageSaved") {
        if (data.success) {
            hasCustomMugshot = !!(data.url && data.url.trim());
            setMugshotFromUrl(data.url || "");
            if (profileImageUrl) profileImageUrl.value = data.url || "";
            showProfileFeedback("Photo enregistrée.", "success");
        } else { showProfileFeedback("URL non autorisée.", "error"); }
    } else if (data.action === "propertyCoordsSaved") {
        if (data.success && currentCitizenProfile) {
            var props = currentCitizenProfile.properties || [];
            for (var i = 0; i < props.length; i++) {
                if ((props[i].name || "") === data.propertyName) {
                    props[i].x = data.x;
                    props[i].y = data.y;
                    break;
                }
            }
        }
    } else if (data.action === "citizenPhotoSaved") {
        if (data.success && currentCitizenProfile && currentCitizenProfile.identifier === data.identifier) {
            currentCitizenProfile.photo = data.url || "";
            profilesRenderDetail(currentCitizenProfile);
        }
    } else if (data.action === "updateMapAgents") {
        updateMapAgents(data.agents || [], data.bounds, data.mapYFlipped, data.mapLinear, data.mapSwapXY, data.mapImageSize, data.mapControlPoints);
    } else if (data.action === "updateDutyState") {
        updateDutyButton(data.onDuty === true);
    } else if (data.action === "close") {
        closeUI();
    } else if (data.action === "hideForCamera") {
        var tabletDev = document.querySelector(".tablet-device");
        var bezel = document.getElementById("cameraBezel");
        if (tabletDev) tabletDev.classList.add("camera-mode-active");
        if (bezel) bezel.classList.remove("hidden");
    } else if (data.action === "showAfterCamera") {
        var tabletDev2 = document.querySelector(".tablet-device");
        var bezel2 = document.getElementById("cameraBezel");
        if (tabletDev2) tabletDev2.classList.remove("camera-mode-active");
        if (bezel2) bezel2.classList.add("hidden");
        if (btnTakePhoto) btnTakePhoto.disabled = false;
        navigateTo("photo");
        var res = data.result;
        if (res && res.success && res.url) {
            photoAddToGallery(res.url);
            showToast("Photo enregistrée");
        } else if (res && res.error) {
            showToast(res.error);
        }
    } else if (data.action === "photoUploadComplete") {
        var res = data.result;
        if (res && res.success && res.url) {
            photoAddToGallery(res.url);
            showToast("Photo enregistrée");
        } else if (res && res.error) {
            showToast(res.error);
        }
    } else if (data.action === "cancelCamera") {
        var tabletDev3 = document.querySelector(".tablet-device");
        var bezel3 = document.getElementById("cameraBezel");
        if (tabletDev3) tabletDev3.classList.remove("camera-mode-active");
        if (bezel3) bezel3.classList.add("hidden");
        if (btnTakePhoto) btnTakePhoto.disabled = false;
    } else if (data.action === "captureTriggered") {
        playCameraShutterSound();
        var shutterEl = document.getElementById("cameraOverlayShutter");
        if (shutterEl) { shutterEl.classList.add("shutter-flash"); setTimeout(function () { shutterEl.classList.remove("shutter-flash"); }, 80); }
    } else if (data.action === "receiveCitizenSearch") {
        updateKnownRedList(data.list || []);
        var citizenList = data.list || [];
        if (warrantsTargetSearching && warrantsTargetResults) {
            warrantsTargetSearching = false;
            populateTargetResults(citizenList, warrantsTargetResults, function (c) { warrantsSelectedTarget = c; if (warrantsTargetSelected) { warrantsTargetSelected.textContent = formatName(c.firstname, c.lastname) + " \u2014 " + (c.identifier || ""); warrantsTargetSelected.classList.remove("hidden"); } warrantsTargetResults.classList.add("hidden"); if (warrantsTargetSearch) warrantsTargetSearch.value = ""; });
        } else if (casiersTargetSearching && casiersTargetResults) {
            casiersTargetSearching = false;
            populateTargetResults(citizenList, casiersTargetResults, function (c) { casiersSelectedTarget = c; if (casiersTargetSelected) { casiersTargetSelected.textContent = formatName(c.firstname, c.lastname) + " \u2014 " + (c.identifier || ""); casiersTargetSelected.classList.remove("hidden"); } casiersTargetResults.classList.add("hidden"); if (casiersTargetSearch) casiersTargetSearch.value = ""; });
        } else if (rapportsTargetSearching && rapportsTargetResults) {
            rapportsTargetSearching = false;
            populateTargetResults(citizenList, rapportsTargetResults, function (c) { rapportsSelectedTarget = c; if (rapportsTargetSelected) { rapportsTargetSelected.textContent = formatName(c.firstname, c.lastname) + " \u2014 " + (c.identifier || ""); rapportsTargetSelected.classList.remove("hidden"); } rapportsTargetResults.classList.add("hidden"); if (rapportsTargetSearch) rapportsTargetSearch.value = ""; });
        } else {
            profilesRenderResults(citizenList);
        }
    } else if (data.action === "receiveWantedCitizens") {
        updateKnownRedList(data.list || []);
        profilesRenderResults(data.list || []);
        if ((data.list || []).length === 0 && profilesResultsList) {
            profilesResultsList.innerHTML = "<li style=\"text-align:center;color:var(--mdt-text2);padding:20px;font-size:13px;\">Aucun individu recherché</li>";
        }
    } else if (data.action === "receiveCitizenProfile") {
        var p = data.profile || {};
        if (p.identifier) {
            knownRedList[p.identifier] = !!p.onRedList;
            syncRecentRedList();
        }
        profilesRenderDetail(p);
        if (pendingSubpageSection) {
            var sec = pendingSubpageSection;
            pendingSubpageSection = null;
            setTimeout(function () { profilesOpenSection(sec); }, 50);
        }
    } else if (data.action === "vehicleSearchByPlateResult") {
        vehiclesRenderResults(data.list || []);
    } else if (data.action === "vehicleSuggestResult") {
        vehiclesRenderSuggestions(data.list || []);
    } else if (data.action === "warrantsSearchResult") {
        warrantsRenderResults(data.list || []);
    } else if (data.action === "receiveActiveWarrants") {
        warrantsLastList = data.list || [];
        warrantsLastAt = Date.now();
        warrantsRenderResults(warrantsLastList);
    } else if (data.action === "warrantCreated") {
        if (warrantsCreateForm) warrantsCreateForm.classList.add("hidden");
        if (warrantsResultsWrap) warrantsResultsWrap.classList.remove("hidden");
        warrantsFormReset();
        warrantsLoadActive(true);
    } else if (data.action === "receiveRecentCasiers") {
        casiersLastList = data.list || [];
        casiersLastAt = Date.now();
        casiersRenderList(casiersLastList);
    } else if (data.action === "receiveCasiersSearch") {
        casiersRenderList(data.list || []);
    } else if (data.action === "casierCreated") {
        if (casiersCreateForm) casiersCreateForm.classList.add("hidden");
        if (casiersResultsWrap) casiersResultsWrap.classList.remove("hidden");
        casiersFormReset();
        casiersLoadRecent(true);
        showToast("Casier créé avec succès");
    } else if (data.action === "receiveRecentReports" || data.action === "receiveReportsSearch") {
        rapportsRenderList(data.list || []);
    } else if (data.action === "reportCreated") {
        if (rapportsCreateForm) rapportsCreateForm.classList.add("hidden");
        if (rapportsResultsWrap) rapportsResultsWrap.classList.remove("hidden");
        rapportsFormReset();
        rapportsLoadRecent();
        showToast("Rapport créé avec succès");
    } else if (data.action === "reportEdited") {
        if (rapportsCreateForm) rapportsCreateForm.classList.add("hidden");
        if (rapportsResultsWrap) rapportsResultsWrap.classList.remove("hidden");
        rapportsFormReset();
        rapportsLoadRecent();
        showToast("Rapport modifié avec succès");
    } else if (data.action === "receiveWantedVehicles") {
        vehiclesRenderWanted(data.list || []);
    } else if (data.action === "wantedVehicleAdded") {
        vehiclesLoadWanted();
        showToast("Véhicule ajouté aux recherchés");
    } else if (data.action === "wantedVehicleRemoved") {
        if (vehiclesDetailPanel) { vehiclesDetailPanel.classList.add("hidden"); }
        if (vehiclesResultsWrap) { vehiclesResultsWrap.classList.remove("hidden"); }
        vehiclesLoadWanted();
        showToast("Véhicule retiré des recherchés");
    } else if (data.action === "editResult") {
        if (data.success) {
            if (casiersCreateForm) casiersCreateForm.classList.add("hidden");
            if (warrantsCreateForm) warrantsCreateForm.classList.add("hidden");
            casiersFormReset();
            showToast("Dossier modifié avec succès");
            if (data.type === "casier") { if (casiersResultsWrap) casiersResultsWrap.classList.remove("hidden"); casiersLoadRecent(true); }
            else if (data.type === "warrant") { if (warrantsResultsWrap) warrantsResultsWrap.classList.remove("hidden"); warrantsLoadActive(true); }
        } else {
            if (data.reason === "grade") showToast("Grade insuffisant (grade 7 minimum requis)");
            else showToast("Erreur lors de la modification");
        }
    } else if (data.action === "deleteResult") {
        if (data.success) {
            sessionDeleteCount++;
            if (sessionDeleteUnlimited || data.remaining === null || data.remaining === undefined) {
                if (sessionDeleteUnlimited) showToast("Supprimé avec succès");
                else showToast("Supprimé avec succès (" + Math.max(0, SESSION_DELETE_MAX - sessionDeleteCount) + " restante" + ((SESSION_DELETE_MAX - sessionDeleteCount) !== 1 ? "s" : "") + ")");
            } else {
                var remaining = data.remaining;
                showToast("Supprimé avec succès (" + remaining + " restante" + (remaining !== 1 ? "s" : "") + ")");
            }
            if (data.type === "warrant") { warrantDetailPanel.classList.add("hidden"); warrantsResultsWrap.classList.remove("hidden"); warrantsLoadActive(true); }
            else if (data.type === "casier") { casiersDetailPanel.classList.add("hidden"); casiersResultsWrap.classList.remove("hidden"); casiersLoadRecent(true); }
            else if (data.type === "report") { rapportsDetailPanel.classList.add("hidden"); rapportsResultsWrap.classList.remove("hidden"); rapportsLoadRecent(); }
        } else {
            if (data.reason === "grade") showToast("Grade insuffisant (grade 5 minimum requis)");
            else if (data.reason === "limit") showToast("Limite de suppressions atteinte (" + SESSION_DELETE_MAX + "/session)");
            else showToast("Erreur lors de la suppression");
        }
    } else if (data.action === "alertsList") {
        alertsRender(data.list || []);
    } else if (data.action === "newAlert") {
        if (data.alert) {
            alertsData.unshift(data.alert);
            alertsRender(alertsData);
            var dotColor = data.alert.urgency === "high" ? "🔴" : (data.alert.urgency === "medium" ? "🟡" : "🟢");
            showToast(dotColor + " Alerte : " + (data.alert.reason || ""));
        }
    } else if (data.action === "panicAlert") {
        showPanicAlert(data);
    }
});

/* ====== TIME ====== */
function updateStatusTime() {
    var d = new Date();
    var t = d.getHours().toString().padStart(2, "0") + ":" + d.getMinutes().toString().padStart(2, "0");
    var el = document.getElementById("statusTime");
    var bootEl = document.getElementById("bootTime");
    if (el) el.textContent = t;
    if (bootEl) bootEl.textContent = t;
}
updateStatusTime();
setInterval(updateStatusTime, 30000);

/* ====== KEYBOARD ====== */
document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeUI();
});

/* ====== DEMO MODE (ouverture directe dans le navigateur) ====== */
(function () {
    var isStandalone = window === window.top;
    var hasDemoParam = (window.location.search || "").indexOf("demo") !== -1;
    if (isStandalone || hasDemoParam) {
        document.body.style.background = "radial-gradient(ellipse 120% 110% at 50% 90%, #18181d 0%, #0a0c12 65%)";
        setTimeout(function () {
            if (app && app.classList.contains("hidden")) {
                openUI({
                    player: { name: "Agent Demo", grade: "Cadet", identifier: "demo" }
                });
                fetch("https://" + resourceName + "/getAlerts", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
                fetch("https://" + resourceName + "/getActiveWarrants", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
                fetch("https://" + resourceName + "/getRecentCasiers", { method: "POST", body: JSON.stringify({}) }).catch(function () {});
            }
        }, 600);
    }
})();
