(function () {
    let isOpen = false;
    let shopItems = [];
    let currentCategory = 1;
    let dirtyMoney = "0$";
    let selectedItem = null;
    let leafletMap = null;
    let territoryLayers = [];
    let leafletMapOverlay = null;

    let nuiResourceName = "sunlife_ui/illtablet";
    let mapAssetResource = "sunlife_ui/apps/poltablet";
    let mapBounds = { minX: -4000, maxX: 4000, minY: -4000, maxY: 4000 };
    let mapImageSize = { width: 2048, height: 2048 };
    let mapControlPoints = [];
    let mapYFlipped = false;
    let mapLinear = true;
    let mapSwapXY = false;
    let mapCalib = null;

    const CATEGORIES = [
        { id: 1, label: "Armes", icon: "fas fa-gun" },
        { id: 2, label: "Objets", icon: "fas fa-toolbox" },
        { id: 3, label: "Munitions", icon: "fas fa-crosshairs" },
    ];

    // GTA V blip color index → hex (from docs.fivem.net/docs/game-references/blips)
    const BLIP_COLORS = {
        0:  "#ffffff", 1:  "#e74c3c", 2:  "#2ecc71", 3:  "#3498db",
        4:  "#ffffff", 5:  "#f1c40f", 6:  "#c0392b", 7:  "#9b59b6",
        8:  "#ff69b4", 9:  "#f0a050", 10: "#b5884e", 11: "#a0d468",
        12: "#7ec8e3", 13: "#c8a2e8", 14: "#6a0dad", 15: "#00ced1",
        16: "#f5f5a0", 17: "#e67e22", 18: "#7ec8e3", 19: "#e91e8c",
        20: "#c8b400", 21: "#d4760a", 22: "#c8c8c8", 23: "#ffb6c1",
        24: "#a4e84e", 25: "#228b22", 26: "#1e90ff", 27: "#8a2be2",
        28: "#c8b400", 29: "#00008b", 30: "#008b8b", 31: "#b5884e",
        32: "#7ec8e3", 33: "#f5f5a0", 34: "#ffb6c1", 35: "#ff6b6b",
        36: "#f5f5dc", 37: "#ffffff", 38: "#3498db", 39: "#b0b0b0",
        40: "#5a5a5a", 41: "#e84073", 42: "#3498db", 43: "#a0d468",
        44: "#f0a050", 45: "#ffffff", 46: "#ffd700", 47: "#e67e22",
        48: "#ff55a3", 49: "#e74c3c", 50: "#9370db", 51: "#fa8072",
        52: "#006400", 53: "#a5d6f6", 54: "#4169e1", 55: "#c0c0c0",
        56: "#8b6914", 57: "#3498db", 58: "#3d5c5c", 59: "#e74c3c",
        60: "#ffae42", 61: "#c54b8c", 62: "#d4d4d4", 63: "#4682b4",
        64: "#d4760a", 65: "#7e6ca8", 66: "#ffae42", 67: "#3498db",
        68: "#3498db", 69: "#2ecc71", 70: "#ffae42", 71: "#ffae42",
        72: "#1a1a1a", 73: "#ffae42", 74: "#3498db", 75: "#e74c3c",
        76: "#8b0000", 77: "#3498db", 78: "#4169e1", 79: "#e74c3c",
        80: "#3498db", 81: "#e67e22", 82: "#a0d468", 83: "#9b59b6",
        84: "#3498db", 85: "#e74c3c",
    };

    function getBlipHex(colorId) {
        return BLIP_COLORS[colorId] || "#ff5a32";
    }

    function getItemIcon(sprite, catId) {
        if (catId === 1) return "fas fa-gun";
        if (catId === 3) return "fas fa-crosshairs";
        return "fas fa-box";
    }

    function getItemIconClass(catId) {
        if (catId === 1) return "icon-weapon";
        if (catId === 3) return "icon-ammo";
        return "icon-tool";
    }

    function formatPrice(price) {
        return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + "$";
    }

    function formatNumber(n) {
        return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function postNUI(event, data) {
        return fetch("https://" + nuiResourceName + "/" + event, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data || {}),
        });
    }

    // ==================== TABS ====================

    function switchTab(tabId) {
        document.querySelectorAll(".nav-item").forEach(function (el) {
            el.classList.toggle("active", el.dataset.tab === tabId);
        });
        document.querySelectorAll(".tab-panel").forEach(function (el) {
            el.classList.remove("active");
        });

        var panelMap = {
            "shop": "panel-shop",
            "ranking-xp": "panel-ranking-xp",
            "ranking-territories": "panel-ranking-territories",
            "ranking-koth": "panel-ranking-koth",
            "groups-online": "panel-groups-online",
            "activities": "panel-activities",
            "map": "panel-map",
        };

        var panel = document.getElementById(panelMap[tabId]);
        if (panel) panel.classList.add("active");

        if (tabId === "activities") {
            renderActivities();
        } else if (tabId === "ranking-xp" || tabId === "ranking-territories") {
            postNUI("getRankings");
        } else if (tabId === "ranking-koth") {
            postNUI("getKothRankings");
        } else if (tabId === "groups-online") {
            postNUI("getGroupsOnline");
        } else if (tabId === "map") {
            postNUI("getMapData");
            setTimeout(function () {
                if (leafletMap) leafletMap.invalidateSize();
            }, 100);
        }
    }

    // ==================== SHOP ====================

    function renderCategories() {
        var container = document.getElementById("shop-categories");
        if (!container) return;

        var html = "";
        CATEGORIES.forEach(function (cat) {
            var count = shopItems[cat.id] ? shopItems[cat.id].length : 0;
            var active = cat.id === currentCategory ? " active" : "";
            html += '<div class="cat-tab' + active + '" data-cat="' + cat.id + '">';
            html += '<i class="' + cat.icon + '"></i>';
            html += "<span>" + cat.label + "</span>";
            html += '<span class="cat-count">' + count + "</span>";
            html += "</div>";
        });
        container.innerHTML = html;

        document.querySelectorAll(".cat-tab").forEach(function (tab) {
            tab.addEventListener("click", function () {
                currentCategory = parseInt(this.dataset.cat);
                renderCategories();
                renderItems();
            });
        });
    }

    function renderItems() {
        var container = document.getElementById("items-grid");
        if (!container) return;

        var catItems = shopItems[currentCategory] || [];

        if (catItems.length === 0) {
            container.innerHTML = '<div class="items-empty"><i class="fas fa-box-open"></i><span>Aucun article</span></div>';
            return;
        }

        var html = "";
        catItems.forEach(function (item) {
            html += '<div class="item-card">';
            html += '<div class="item-card-visual">';
            html += '<img class="item-card-img" src="img/items/' + item.sprite + '.png" onerror="this.style.display=\'none\';this.nextElementSibling.style.display=\'flex\'">';
            html += '<i class="item-icon ' + getItemIcon(item.sprite, currentCategory) + " " + getItemIconClass(currentCategory) + '" style="display:none"></i>';
            html += '<div class="item-card-price-tag">' + formatPrice(item.price) + "</div>";
            html += "</div>";
            html += '<div class="item-card-info">';
            html += '<div class="item-card-name">' + item.name + "</div>";
            html += '<button class="btn-buy" data-sprite="' + item.sprite + '" data-name="' + item.name + '" data-price="' + item.price + '">';
            html += '<i class="fas fa-cart-shopping"></i> Acheter';
            html += "</button>";
            html += "</div></div>";
        });
        container.innerHTML = html;

        document.querySelectorAll(".btn-buy").forEach(function (btn) {
            btn.addEventListener("click", function (e) {
                e.stopPropagation();
                openBuyModal({
                    sprite: this.dataset.sprite,
                    name: this.dataset.name,
                    price: parseInt(this.dataset.price),
                });
            });
        });
    }

    // ==================== BUY MODAL ====================

    function openBuyModal(item) {
        selectedItem = item;
        document.getElementById("modal-item-name").textContent = item.name;
        document.getElementById("modal-item-price").textContent = formatPrice(item.price) + " / unité";
        document.getElementById("modal-item-icon").className = "item-icon " + getItemIcon(item.sprite, currentCategory) + " " + getItemIconClass(currentCategory);
        document.getElementById("buy-quantity").value = 1;
        updateTotal();
        document.getElementById("modal-buy").classList.add("visible");
    }

    function closeBuyModal() {
        document.getElementById("modal-buy").classList.remove("visible");
        selectedItem = null;
    }

    function updateTotal() {
        if (!selectedItem) return;
        var qty = parseInt(document.getElementById("buy-quantity").value) || 1;
        document.getElementById("buy-total").textContent = formatPrice(selectedItem.price * qty);
    }

    function confirmBuy() {
        if (!selectedItem) return;
        var qty = parseInt(document.getElementById("buy-quantity").value) || 1;
        if (qty <= 0) return;
        postNUI("buyItem", {
            sprite: selectedItem.sprite,
            name: selectedItem.name,
            price: selectedItem.price,
            quantity: qty,
        });
        closeBuyModal();
    }

    // ==================== RANKINGS ====================

    function renderRankingXP(data) {
        var container = document.getElementById("ranking-xp-list");
        var headerHTML = '<div class="ranking-header-row"><span class="rh-pos">#</span><span class="rh-name">Groupe</span><span class="rh-stat">Niveau</span><span class="rh-stat">XP</span><span class="rh-stat">Membres</span><span class="rh-stat">Score</span></div>';

        if (!data || data.length === 0) {
            container.innerHTML = headerHTML + '<div class="ranking-empty"><i class="fas fa-trophy"></i><span>Aucun groupe</span></div>';
            return;
        }

        var html = headerHTML;
        data.forEach(function (g, i) {
            var topClass = i === 0 ? " top-1" : i === 1 ? " top-2" : i === 2 ? " top-3" : "";
            html += '<div class="ranking-row' + topClass + '">';
            html += '<span class="rank-pos">' + (i + 1) + "</span>";
            html += '<span class="rank-name">' + g.name + "</span>";
            html += '<span class="rank-stat">' + g.level + "</span>";
            html += '<span class="rank-stat dim">' + formatNumber(g.xp) + "</span>";
            html += '<span class="rank-stat dim">' + g.members + "</span>";
            html += '<span class="rank-stat">' + formatNumber(g.score) + "</span>";
            html += "</div>";
        });
        container.innerHTML = html;
    }

    function renderRankingTerritories(data) {
        var container = document.getElementById("ranking-territories-list");
        var headerHTML = '<div class="ranking-header-row"><span class="rh-pos">#</span><span class="rh-name">Groupe</span><span class="rh-stat">Territoires</span></div>';

        if (!data || data.length === 0) {
            container.innerHTML = headerHTML + '<div class="ranking-empty"><i class="fas fa-flag"></i><span>Aucun territoire possédé</span></div>';
            return;
        }

        var html = headerHTML;
        data.forEach(function (g, i) {
            var topClass = i === 0 ? " top-1" : i === 1 ? " top-2" : i === 2 ? " top-3" : "";
            html += '<div class="ranking-row' + topClass + '">';
            html += '<span class="rank-pos">' + (i + 1) + "</span>";
            html += '<span class="rank-name">' + g.name + "</span>";
            html += '<span class="rank-stat">' + g.count + "</span>";
            html += "</div>";
        });
        container.innerHTML = html;
    }

    // ==================== KOTH RANKING (style boutique) ====================

    function initialsFromName(name) {
        var s = String(name || "").trim();
        if (!s) return "?";
        var parts = s.split(/\s+/);
        if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
        return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    function trophySVG(rank) {
        return '<svg viewBox="0 0 64 64" width="64" height="64" aria-hidden="true">' +
            '<defs>' +
                '<linearGradient id="kothTrophyGrad-' + rank + '" x1="0" y1="0" x2="0" y2="1">' +
                    '<stop offset="0%" stop-color="currentColor" stop-opacity="1"/>' +
                    '<stop offset="100%" stop-color="currentColor" stop-opacity="0.55"/>' +
                '</linearGradient>' +
            '</defs>' +
            '<path d="M14 14h-4a4 4 0 0 0-4 4v4a8 8 0 0 0 8 8h2" fill="none" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>' +
            '<path d="M50 14h4a4 4 0 0 1 4 4v4a8 8 0 0 1-8 8h-2" fill="none" stroke="currentColor" stroke-width="3" stroke-linejoin="round"/>' +
            '<path d="M14 8h36v14a18 18 0 0 1-36 0z" fill="url(#kothTrophyGrad-' + rank + ')" stroke="currentColor" stroke-width="2.5" stroke-linejoin="round"/>' +
            '<rect x="26" y="40" width="12" height="6" rx="1" fill="currentColor"/>' +
            '<rect x="20" y="46" width="24" height="6" rx="2" fill="currentColor"/>' +
            '<path d="M32 14l1.6 3.4 3.7.5-2.7 2.6.7 3.7L32 22.5 28.7 24.2l.7-3.7-2.7-2.6 3.7-.5z" fill="#fff" opacity="0.85"/>' +
        '</svg>';
    }

    function renderKothRanking(data) {
        var page = document.getElementById("koth-ranking-page");
        if (!page) return;

        var list = Array.isArray(data) ? data.slice() : [];
        // On ne garde que ceux qui ont au moins 1 point (donc 1 win min).
        list = list.filter(function (g) { return (Number(g.points) || 0) > 0; });

        if (list.length === 0) {
            page.innerHTML = '<div class="koth-empty"><i class="fas fa-crown"></i><span>Aucun groupe classé</span></div>';
            return;
        }

        // Top 10 max, top 3 sur le podium.
        var all = list.slice(0, 10).map(function (g, i) {
            return {
                name: String(g.name || "?"),
                points: Number(g.points) || 0,
                wins: Number(g.wins) || 0,
                rank: i + 1,
            };
        });

        var top3 = all.slice(0, 3);
        // Ordre visuel : 2e, 1er, 3e.
        var podiumOrder = [top3[1], top3[0], top3[2]].filter(Boolean);

        var podiumHTML = '<div class="koth-podium">';
        podiumOrder.forEach(function (p) {
            podiumHTML += '<div class="koth-slot rank-' + p.rank + '">';
            podiumHTML +=   '<div class="koth-trophy">' + trophySVG(p.rank) + '</div>';
            podiumHTML +=   '<div class="koth-avatar">' + initialsFromName(p.name) + '</div>';
            podiumHTML +=   '<div class="koth-name">' + p.name + '</div>';
            podiumHTML +=   '<div class="koth-amount">';
            podiumHTML +=     '<span class="amt-num">' + formatNumber(p.points) + '</span>';
            podiumHTML +=     '<span class="amt-lbl">' + (p.points > 1 ? 'pts' : 'pt') + '</span>';
            podiumHTML +=   '</div>';
            podiumHTML +=   '<div class="koth-base"><span class="koth-pos">#' + p.rank + '</span></div>';
            podiumHTML += '</div>';
        });
        podiumHTML += '</div>';

        var rest = all.slice(3);
        var restHTML = '';
        if (rest.length) {
            restHTML += '<div class="koth-list">';
            rest.forEach(function (r) {
                restHTML += '<div class="koth-row">';
                restHTML +=   '<div class="koth-row-pos">#' + r.rank + '</div>';
                restHTML +=   '<div class="koth-row-avatar">' + initialsFromName(r.name) + '</div>';
                restHTML +=   '<div class="koth-row-meta">';
                restHTML +=     '<div class="koth-row-name">' + r.name + '</div>';
                restHTML +=     '<div class="koth-row-sub">Top ' + r.rank + ' KOTH</div>';
                restHTML +=   '</div>';
                restHTML +=   '<div class="koth-row-amount">';
                restHTML +=     '<span class="amt-num">' + formatNumber(r.points) + '</span>';
                restHTML +=     '<span class="amt-lbl">' + (r.points > 1 ? 'pts' : 'pt') + '</span>';
                restHTML +=   '</div>';
                restHTML += '</div>';
            });
            restHTML += '</div>';
        }

        page.innerHTML = podiumHTML + restHTML;
    }

    // ==================== GROUPS ONLINE ====================

    function renderGroupsOnline(data) {
        var container = document.getElementById("groups-online-list");
        var headerHTML = '<div class="ranking-header-row"><span class="rh-pos">#</span><span class="rh-name">Groupe</span><span class="rh-stat">Connectés</span><span class="rh-stat">Membres</span></div>';

        if (!data || data.length === 0) {
            container.innerHTML = headerHTML + '<div class="ranking-empty"><i class="fas fa-users-slash"></i><span>Aucun groupe</span></div>';
            return;
        }

        var html = headerHTML;
        data.forEach(function (g, i) {
            var topClass = i === 0 ? " top-1" : i === 1 ? " top-2" : i === 2 ? " top-3" : "";
            html += '<div class="ranking-row' + topClass + '">';
            html += '<span class="rank-pos">' + (i + 1) + "</span>";
            html += '<span class="rank-name">' + g.name + "</span>";
            html += '<span class="rank-stat">' + g.online + "/" + g.members + "</span>";
            html += '<span class="rank-stat dim">' + g.members + "</span>";
            html += "</div>";
        });
        container.innerHTML = html;
    }

    // ==================== ACTIVITIES ====================

    var activitiesList = [];
    var selectedActivityId = null;

    function findActivityById(id) {
        if (!id || !activitiesList.length) return null;
        for (var i = 0; i < activitiesList.length; i++) {
            if (activitiesList[i].id === id) return activitiesList[i];
        }
        return null;
    }

    function openActivityModal(act) {
        if (!act) return;
        selectedActivityId = act.id;

        var titleEl = document.getElementById("modal-activity-title");
        var descEl = document.getElementById("modal-activity-desc");
        var imgEl = document.getElementById("modal-activity-img");
        var fallbackEl = document.getElementById("modal-activity-fallback");

        titleEl.textContent = act.name;
        descEl.textContent = act.description || "Aucune description.";

        if (act.image) {
            imgEl.style.display = "block";
            fallbackEl.style.display = "none";
            imgEl.src = act.image;
            imgEl.alt = act.name;
            imgEl.onerror = function () {
                imgEl.style.display = "none";
                fallbackEl.style.display = "flex";
            };
        } else {
            imgEl.style.display = "none";
            imgEl.removeAttribute("src");
            fallbackEl.style.display = "flex";
        }

        document.getElementById("modal-activity").classList.add("visible");
    }

    function closeActivityModal() {
        selectedActivityId = null;
        var overlay = document.getElementById("modal-activity");
        if (overlay) overlay.classList.remove("visible");
        var imgEl = document.getElementById("modal-activity-img");
        if (imgEl) {
            imgEl.onload = null;
            imgEl.onerror = null;
        }
    }

    function renderActivities() {
        var container = document.getElementById("activities-grid");
        if (!container) return;

        if (!activitiesList || activitiesList.length === 0) {
            container.innerHTML = '<div class="items-empty"><i class="fas fa-mask"></i><span>Aucune activité</span></div>';
            return;
        }

        var html = "";
        activitiesList.forEach(function (act) {
            html += '<div class="item-card activity-card" data-id="' + act.id + '" title="Cliquer pour voir les détails">';
            html += '<div class="item-card-visual activity-visual">';
            if (act.image) {
                html += '<img class="activity-img" src="' + act.image + '" alt="' + act.name + '">';
            } else {
                html += '<i class="item-icon fas fa-mask icon-tool"></i>';
            }
            html += "</div>";
            html += '<div class="item-card-info activity-card-footer">';
            html += '<div class="item-card-name">' + act.name + "</div>";
            html += '<span class="activity-card-hint"><i class="fas fa-circle-info"></i></span>';
            html += "</div></div>";
        });
        container.innerHTML = html;

        document.querySelectorAll(".activity-card").forEach(function (card) {
            card.addEventListener("click", function () {
                var act = findActivityById(this.dataset.id);
                if (act) openActivityModal(act);
            });
        });
    }

    // ==================== MAP (même logique que SNL_PolTablet) ====================

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
        return {
            lat: bounds.maxY - (py / calib.imgH) * (bounds.maxY - bounds.minY),
            lng: bounds.minX + (px / calib.imgW) * (bounds.maxX - bounds.minX)
        };
    }

    function applyMapConfig(data) {
        if (!data) return;
        if (data.mapBounds) mapBounds = data.mapBounds;
        if (data.mapImageSize) mapImageSize = data.mapImageSize;
        if (data.mapControlPoints) mapControlPoints = data.mapControlPoints;
        if (data.mapYFlipped !== undefined) mapYFlipped = !!data.mapYFlipped;
        if (data.mapLinear !== undefined) mapLinear = !!data.mapLinear;
        if (data.mapSwapXY !== undefined) mapSwapXY = !!data.mapSwapXY;
        mapCalib = computeCalibration(mapControlPoints, mapImageSize);
    }

    function gameXYToLeafletLatLng(gameX, gameY) {
        if (mapCalib) {
            var pt = gameToMapLatLng(gameX, gameY, mapCalib, mapBounds);
            if (!pt) return null;
            return [pt.lat, pt.lng];
        }
        var y = mapYFlipped ? -gameY : gameY;
        var lat = mapSwapXY ? gameX : y;
        var lng = mapSwapXY ? y : gameX;
        return [lat, lng];
    }

    function initMap() {
        if (leafletMap) return;

        // Leaflet est vendorise en local, mais on reste defensif : si le script
        // n'a pas pu s'evaluer, on affiche un message dans l'onglet plutot que
        // de laisser une ReferenceError casser le handler de messages.
        if (typeof L === "undefined") {
            var host = document.getElementById("territory-map");
            if (host) host.innerHTML = '<div class="ranking-empty"><i class="fas fa-map"></i><span>Carte indisponible</span></div>';
            return;
        }

        var b = mapBounds;
        var southWest = L.latLng(b.minY, b.minX);
        var northEast = L.latLng(b.maxY, b.maxX);
        var bounds = L.latLngBounds(southWest, northEast);

        leafletMap = L.map("territory-map", {
            crs: L.CRS.Simple,
            center: [(b.minY + b.maxY) / 2, (b.minX + b.maxX) / 2],
            zoom: -2,
            minZoom: -3,
            maxZoom: 4,
            bounceAtZoomLimits: true,
            maxBoundsViscosity: 0.95,
            maxBounds: bounds,
            preferCanvas: false,
            zoomControl: true,
            attributionControl: false,
            boxZoom: false,
        });

        var assetBase = "nui://" + mapAssetResource + "/ui/assets";
        var imgUrl = assetBase + "/map.png";
        leafletMapOverlay = L.imageOverlay(imgUrl, bounds, { className: "map-overlay" }).addTo(leafletMap);
        leafletMapOverlay.on("error", function () {
            leafletMapOverlay.setUrl(assetBase + "/map.svg");
        });

        leafletMap.fitBounds(bounds, { animate: false });
        [100, 300, 600].forEach(function (ms) {
            setTimeout(function () {
                if (leafletMap) leafletMap.invalidateSize();
            }, ms);
        });
    }

    function renderMapZones(zones, territories) {
        if (!leafletMap) initMap();
        // initMap() peut avoir renonce (Leaflet indisponible) : sans ce garde,
        // L.polygon plus bas leve une ReferenceError.
        if (!leafletMap) return;

        territoryLayers.forEach(function (l) { leafletMap.removeLayer(l); });
        territoryLayers = [];

        if (!zones || !Array.isArray(zones)) return;

        zones.forEach(function (zone) {
            if (!zone.poly || zone.poly.length < 3) return;

            var latlngs = [];
            for (var pi = 0; pi < zone.poly.length; pi++) {
                var p = zone.poly[pi];
                var ll = gameXYToLeafletLatLng(p.x, p.y);
                if (ll) latlngs.push(ll);
            }
            if (latlngs.length < 3) return;

            var ownerData = null;
            if (territories) {
                ownerData = territories[zone.name];
            }

            var color = "#555";
            var ownerName = "Libre";
            if (ownerData && ownerData.owner) {
                color = getBlipHex(ownerData.color);
                ownerName = ownerData.owner;
            }

            var polygon = L.polygon(latlngs, {
                color: color,
                weight: 2,
                opacity: 0.8,
                fillColor: color,
                fillOpacity: 0.25,
            });

            polygon.bindTooltip(
                '<div class="territory-tooltip"><div class="tt-name">' + zone.name + '</div><div class="tt-owner" style="color:' + color + '">' + ownerName + "</div></div>",
                { className: "territory-tooltip", sticky: true }
            );

            polygon.addTo(leafletMap);
            territoryLayers.push(polygon);
        });

        if (territoryLayers.length > 0) {
            var group = L.featureGroup(territoryLayers);
            leafletMap.fitBounds(group.getBounds().pad(0.1));
        }
    }

    // ==================== MAIN ====================

    function open(data) {
        if (isOpen) return;
        isOpen = true;

        applyMapConfig(data);

        var rawItems = data.items || {};
        shopItems = {};
        if (Array.isArray(rawItems)) {
            for (var ci = 0; ci < rawItems.length; ci++) {
                shopItems[ci + 1] = rawItems[ci];
            }
        } else {
            shopItems = rawItems;
        }
        dirtyMoney = data.dirtyMoney || "0$";
        activitiesList = data.activities || [];
        currentCategory = 1;

        document.getElementById("tablet-app").classList.add("visible");
        document.getElementById("dirty-money-value").textContent = dirtyMoney;

        switchTab("shop");
        renderCategories();
        renderItems();

        // Confirme au client Lua que le panneau est bien affiche : sans ce
        // signal il relache le focus NUI au bout de quelques secondes pour ne
        // pas laisser le joueur bloque avec un curseur et rien a l'ecran.
        postNUI("uiReady");
    }

    function close() {
        if (!isOpen) return;
        isOpen = false;
        document.getElementById("tablet-app").classList.remove("visible");
        closeBuyModal();
        closeActivityModal();
    }

    window.addEventListener("message", function (event) {
        var data = event.data;
        // Le routeur n'est pas la seule source de postMessage dans l'iframe
        // (extensions, libs tierces...) : on ignore tout ce qui n'est pas une
        // payload de l'app, sinon un TypeError casse ce handler.
        if (!data || typeof data !== "object" || !data.type) return;

        switch (data.type) {
            case "open":
                open(data);
                break;
            case "close":
                close();
                break;
            case "updateDirty":
                dirtyMoney = data.dirtyMoney || "0$";
                document.getElementById("dirty-money-value").textContent = dirtyMoney;
                break;
            case "rankingsData":
                renderRankingXP(data.rankingXP || []);
                renderRankingTerritories(data.rankingTerritories || []);
                break;
            case "kothRankingsData":
                renderKothRanking(data.rankings || []);
                break;
            case "groupsOnlineData":
                renderGroupsOnline(data.groups || []);
                break;
            case "mapData":
                applyMapConfig(data);
                initMap();
                renderMapZones(data.zones || [], data.territories || {});
                break;
        }
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" || e.key === "Backspace") {
            var actModal = document.getElementById("modal-activity");
            if (actModal && actModal.classList.contains("visible")) {
                closeActivityModal();
                e.preventDefault();
                return;
            }
            if (selectedItem) {
                closeBuyModal();
            } else if (isOpen) {
                postNUI("close");
            }
        }
    });

    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById("btn-close-tablet").addEventListener("click", function () {
            postNUI("close");
        });

        document.querySelectorAll(".nav-item").forEach(function (item) {
            item.addEventListener("click", function () {
                switchTab(this.dataset.tab);
            });
        });

        document.getElementById("modal-buy-close").addEventListener("click", closeBuyModal);
        document.getElementById("modal-buy-cancel").addEventListener("click", closeBuyModal);
        document.getElementById("modal-buy-confirm").addEventListener("click", confirmBuy);

        document.getElementById("qty-minus").addEventListener("click", function () {
            var input = document.getElementById("buy-quantity");
            var val = parseInt(input.value) || 1;
            if (val > 1) input.value = val - 1;
            updateTotal();
        });

        document.getElementById("qty-plus").addEventListener("click", function () {
            var input = document.getElementById("buy-quantity");
            var val = parseInt(input.value) || 1;
            if (val < 999) input.value = val + 1;
            updateTotal();
        });

        document.getElementById("buy-quantity").addEventListener("input", function () {
            var val = parseInt(this.value);
            if (isNaN(val) || val < 1) this.value = 1;
            if (val > 999) this.value = 999;
            updateTotal();
        });

        document.getElementById("modal-activity-close").addEventListener("click", closeActivityModal);
        document.getElementById("modal-activity-cancel").addEventListener("click", closeActivityModal);
        document.getElementById("modal-activity-locate").addEventListener("click", function () {
            if (!selectedActivityId) return;
            postNUI("locateActivity", { id: selectedActivityId });
            closeActivityModal();
        });
        document.getElementById("modal-activity").addEventListener("click", function (e) {
            if (e.target === this) closeActivityModal();
        });
    });
})();
