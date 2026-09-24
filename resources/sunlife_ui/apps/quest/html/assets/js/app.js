$(document).ready(function () {
    let currentTab = "quests";
    let cachedData = null;

    function postNUI(endpoint, data) {
        return $.ajax({
            type: "POST",
            url: "https://sunlife_ui/quest/" + endpoint,
            data: JSON.stringify(data || {}),
            dataType: "json",
        });
    }

    function showApp() {
        $("#quest-app").css("display", "block");
        switchTab("quests");
    }

    function hideApp() {
        $("#quest-app").css("display", "none");
        postNUI("close");
    }

    window.addEventListener("message", function (event) {
        const d = event.data;
        if (d.type === "open") {
            showApp();
            loadQuests();
        }
        if (d.type === "close") {
            $("#quest-app").css("display", "none");
        }
        if (d.type === "questCompleted" && cachedData) {
            cachedData.completed[d.questId] = true;
            cachedData.xp = d.totalXp;
            renderQuests(cachedData);
            updateStats(cachedData);
        }
    });

    $(document).keydown(function (e) {
        if (e.key === "Escape" && $("#quest-app").css("display") !== "none") {
            hideApp();
        }
    });

    function switchTab(tab) {
        currentTab = tab;
        $(".nav-item").removeClass("active");
        $(`.nav-item[data-tab="${tab}"]`).addClass("active");
        $(".tab-content").removeClass("active");

        if (tab === "quests") {
            $("#tab-quests").addClass("active");
        } else if (tab === "leaderboard") {
            $("#tab-leaderboard").addClass("active");
            loadLeaderboard();
        }
    }

    $(".nav-item").on("click", function () {
        switchTab($(this).data("tab"));
    });

    $("#btn-close").on("click", function () {
        hideApp();
    });

    function loadQuests() {
        const container = $("#quest-list");
        container.html('<div class="loading-spinner"><i class="fas fa-circle-notch"></i></div>');

        postNUI("getData").done(function (data) {
            if (!data) return;
            cachedData = data;
            if (!cachedData.completed) cachedData.completed = {};
            renderQuests(data);
            updateStats(data);
        });
    }

    function renderQuests(data) {
        const container = $("#quest-list");
        container.empty();

        const quests = data.quests || [];
        const completed = data.completed || {};

        quests.forEach(function (quest) {
            const done = completed[quest.id] === true;
            const cardClass = done ? "quest-card completed" : "quest-card";
            const iconClass = done ? "fas fa-circle-check" : "fas fa-circle";
            const statusText = done ? "COMPLÉTÉE" : "EN COURS";
            const statusClass = done ? "quest-status done" : "quest-status pending";
            const rewardClass = done ? "quest-reward claimed" : "quest-reward";

            container.append(`
                <div class="${cardClass}">
                    <div class="quest-card-icon"><i class="${iconClass}"></i></div>
                    <div class="quest-card-info">
                        <div class="quest-card-name">${quest.label}</div>
                        <div class="quest-card-rewards">
                            <span class="reward-money"><i class="fas fa-dollar-sign"></i> 5 000$</span>
                            <span class="reward-xp"><i class="fas fa-star"></i> 50 XP</span>
                        </div>
                    </div>
                    <div class="${statusClass}">${statusText}</div>
                </div>
            `);
        });
    }

    function updateStats(data) {
        const quests = data.quests || [];
        const completed = data.completed || {};
        let doneCount = 0;
        quests.forEach(function (q) { if (completed[q.id]) doneCount++; });

        $("#my-xp").text(formatNumber(data.xp || 0));
        $("#completed-count").text(doneCount);
        $("#total-count").text(quests.length);

        const pct = quests.length > 0 ? (doneCount / quests.length) * 100 : 0;
        $("#progress-fill").css("width", pct + "%");
    }

    const LEADERBOARD_DISPLAY_LIMIT = 50;

    function loadLeaderboard() {
        const container = $("#ranking-list");
        container.html('<div class="loading-spinner"><i class="fas fa-circle-notch"></i></div>');

        postNUI("getLeaderboard").done(function (data) {
            container.empty();

            if (!data || data.length === 0) {
                container.html('<div class="quest-empty"><i class="fas fa-trophy"></i><span>Aucun classement disponible</span></div>');
                return;
            }

            const top = data.slice(0, LEADERBOARD_DISPLAY_LIMIT);

            container.append(`
                <div class="ranking-header">
                    <span class="rh-pos">#</span>
                    <span class="rh-medal"></span>
                    <span class="rh-name">Joueur (Top ${LEADERBOARD_DISPLAY_LIMIT})</span>
                    <span class="rh-stat">XP</span>
                    <span class="rh-label">Quêtes</span>
                </div>
            `);

            top.forEach(function (player) {
                const pos = player.position;
                const medal = pos === 1 ? "🏆" : pos === 2 ? "🥈" : pos === 3 ? "🥉" : "";
                const topClass = pos <= 3 ? "top-" + pos : "";

                container.append(`
                    <div class="ranking-row ${topClass}">
                        <div class="ranking-position">${pos}</div>
                        <div class="ranking-medal">${medal}</div>
                        <div class="ranking-name">${player.name}</div>
                        <div class="ranking-stat">${formatNumber(player.xp)}</div>
                        <div class="ranking-stat-label">${player.quests} quêtes</div>
                    </div>
                `);
            });
        });
    }

    function formatNumber(num) {
        if (!num) return "0";
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }
});
