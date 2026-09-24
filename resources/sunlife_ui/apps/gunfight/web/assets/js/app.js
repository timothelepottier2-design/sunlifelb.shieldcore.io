$(document).ready(function () {
    let currentTab = "lobbies";
    let pendingJoinLobbyId = null;
    let isInZone = false;
    let myServerId = 0;

    function postNUI(endpoint, data) {
        return $.ajax({
            type: "POST",
            url: "https://sunlife_ui/gunfight/" + endpoint,
            data: JSON.stringify(data || {}),
            dataType: "json",
        });
    }

    function showApp() {
        $("#lobby-app").css("display", "block");
        switchTab("lobbies");
        loadLobbies();
    }

    function hideApp() {
        $("#lobby-app").css("display", "none");
        $("#modal-create").css("display", "none");
        $("#modal-password").css("display", "none");
        postNUI("closeLobby");
    }

    // ============================================================
    // NUI MESSAGE LISTENER
    // ============================================================

    window.addEventListener("message", function (event) {
        const data = event.data;

        if (data.type === "openLobby") {
            isInZone = data.inZone || false;
            myServerId = data.myServerId || 0;
            if (isInZone) {
                $("#btn-leave-lobby").css("display", "flex");
            } else {
                $("#btn-leave-lobby").css("display", "none");
            }
            showApp();
        }

        if (data.type === "closeLobby") {
            $("#lobby-app").css("display", "none");
        }
    });

    // ============================================================
    // KEYBOARD
    // ============================================================

    $(document).keydown(function (e) {
        if (e.key === "Escape") {
            if ($("#modal-create").css("display") !== "none") {
                $("#modal-create").css("display", "none");
                return;
            }
            if ($("#modal-password").css("display") !== "none") {
                $("#modal-password").css("display", "none");
                return;
            }
            if ($("#lobby-app").css("display") !== "none") {
                hideApp();
            }
        }
    });

    // ============================================================
    // TAB NAVIGATION
    // ============================================================

    function switchTab(tab) {
        currentTab = tab;
        $(".nav-item").removeClass("active");
        $(`.nav-item[data-tab="${tab}"]`).addClass("active");
        $(".tab-content").removeClass("active");

        if (tab === "lobbies") {
            $("#tab-lobbies").addClass("active");
            loadLobbies();
        } else if (tab === "ranking-kills") {
            $("#tab-ranking-kills").addClass("active");
            loadRankingKills();
        } else if (tab === "ranking-kd") {
            $("#tab-ranking-kd").addClass("active");
            loadRankingKd();
        }
    }

    $(".nav-item").on("click", function () {
        const tab = $(this).data("tab");
        switchTab(tab);
    });

    // ============================================================
    // CLOSE / LEAVE
    // ============================================================

    $("#btn-close").on("click", function () {
        hideApp();
    });

    $("#btn-leave-lobby").on("click", function () {
        postNUI("leaveLobby");
        $("#lobby-app").css("display", "none");
    });

    // ============================================================
    // LOBBY LIST
    // ============================================================

    function loadLobbies() {
        const container = $("#lobby-list");
        container.html('<div class="loading-spinner"><i class="fas fa-circle-notch"></i></div>');

        postNUI("getLobbies").done(function (lobbies) {
            container.empty();

            if (!lobbies || lobbies.length === 0) {
                container.html(
                    '<div class="lobby-empty"><i class="fas fa-ghost"></i><span>Aucun lobby disponible</span></div>'
                );
                return;
            }

            lobbies.forEach(function (lobby) {
                const isGlobal = lobby.id === "global";
                const isFull = lobby.playerCount >= lobby.maxPlayers;
                const hasLock = lobby.hasPassword;
                const isMyLobby = !isGlobal && lobby.creatorId && lobby.creatorId === myServerId;

                const cardClass = isGlobal ? "lobby-card global-lobby" : "lobby-card custom-lobby";
                const iconClass = isGlobal ? "fas fa-globe" : "fas fa-user-shield";
                const lockHtml = hasLock ? '<i class="fas fa-lock lock-icon"></i>' : "";
                const joinBtnClass = isFull ? "btn-join full" : "btn-join";
                const joinBtnText = isFull ? "COMPLET" : "REJOINDRE";
                const descText = lobby.description || (isGlobal ? "Lobby FFA ouvert à tous" : "Pas de description");
                const deleteBtnHtml = isMyLobby
                    ? '<button class="btn-delete-lobby" title="Supprimer votre lobby"><i class="fas fa-trash-alt"></i></button>'
                    : "";

                const card = $(`
                    <div class="${cardClass}" data-lobby-id="${lobby.id}" data-has-password="${hasLock}">
                        <div class="lobby-card-icon"><i class="${iconClass}"></i></div>
                        <div class="lobby-card-info">
                            <div class="lobby-card-name">${lobby.name} ${lockHtml}</div>
                            <div class="lobby-card-desc">${descText}</div>
                        </div>
                        <div class="lobby-card-meta">
                            <div class="lobby-card-players">
                                <i class="fas fa-users"></i>
                                <span class="count-current">${lobby.playerCount}</span>
                                <span class="count-sep">/</span>
                                <span>${lobby.maxPlayers}</span>
                            </div>
                        </div>
                        ${deleteBtnHtml}
                        <button class="${joinBtnClass}" ${isFull ? "disabled" : ""}>${joinBtnText}</button>
                    </div>
                `);

                if (isMyLobby) {
                    card.find(".btn-delete-lobby").on("click", function (e) {
                        e.stopPropagation();
                        postNUI("deleteLobby");
                        loadLobbies();
                    });
                }

                if (!isFull) {
                    card.find(".btn-join").on("click", function () {
                        const lobbyId = card.data("lobby-id");
                        const hasPwd = card.data("has-password");

                        if (hasPwd) {
                            pendingJoinLobbyId = lobbyId;
                            $("#password-input").val("");
                            $("#modal-password").css("display", "flex");
                        } else {
                            postNUI("joinLobby", { lobbyId: lobbyId, password: null });
                            $("#lobby-app").css("display", "none");
                        }
                    });
                }

                container.append(card);
            });
        });
    }

    // ============================================================
    // CREATE LOBBY MODAL
    // ============================================================

    $("#btn-create-lobby").on("click", function () {
        $("#create-max-players").val(10);
        $("#create-description").val("");
        $("#create-password").val("");
        $("#modal-create").css("display", "flex");
    });

    $("#modal-create-close, #modal-create-cancel").on("click", function () {
        $("#modal-create").css("display", "none");
    });

    $("#modal-create-confirm").on("click", function () {
        const maxPlayers = parseInt($("#create-max-players").val()) || 10;
        const description = $("#create-description").val() || "";
        const password = $("#create-password").val() || "";

        postNUI("createLobby", {
            maxPlayers: maxPlayers,
            description: description,
            password: password,
        });

        $("#modal-create").css("display", "none");
        $("#lobby-app").css("display", "none");
    });

    // ============================================================
    // PASSWORD MODAL
    // ============================================================

    $("#modal-password-close, #modal-password-cancel").on("click", function () {
        $("#modal-password").css("display", "none");
        pendingJoinLobbyId = null;
    });

    $("#modal-password-confirm").on("click", function () {
        const password = $("#password-input").val() || "";

        if (pendingJoinLobbyId) {
            postNUI("joinLobby", { lobbyId: pendingJoinLobbyId, password: password });
            $("#modal-password").css("display", "none");
            $("#lobby-app").css("display", "none");
            pendingJoinLobbyId = null;
        }
    });

    $("#password-input").on("keydown", function (e) {
        if (e.key === "Enter") {
            $("#modal-password-confirm").click();
        }
    });

    // ============================================================
    // RANKINGS
    // ============================================================

    function getMedal(pos) {
        if (pos === 1) return "🏆";
        if (pos === 2) return "🥈";
        if (pos === 3) return "🥉";
        return "";
    }

    function getTopClass(pos) {
        if (pos === 1) return "top-1";
        if (pos === 2) return "top-2";
        if (pos === 3) return "top-3";
        return "";
    }

    function loadRankingKills() {
        const container = $("#ranking-kills-list");
        container.html('<div class="loading-spinner"><i class="fas fa-circle-notch"></i></div>');

        postNUI("getClassement").done(function (data) {
            container.empty();

            if (!data || data.length === 0) {
                container.html(
                    '<div class="lobby-empty"><i class="fas fa-trophy"></i><span>Aucun classement disponible</span></div>'
                );
                return;
            }

            container.append(`
                <div class="ranking-header">
                    <span class="rh-pos">#</span>
                    <span class="rh-medal"></span>
                    <span class="rh-name">Joueur</span>
                    <span class="rh-stat">Kills</span>
                    <span class="rh-label"></span>
                </div>
            `);

            data.forEach(function (player, index) {
                const pos = index + 1;
                const medal = getMedal(pos);
                const topClass = getTopClass(pos);

                container.append(`
                    <div class="ranking-row ${topClass}">
                        <div class="ranking-position">${pos}</div>
                        <div class="ranking-medal">${medal}</div>
                        <div class="ranking-name">${player.playerName}</div>
                        <div class="ranking-stat">${formatNumber(player.kills)}</div>
                        <div class="ranking-stat-label">kills</div>
                    </div>
                `);
            });
        });
    }

    function loadRankingKd() {
        const container = $("#ranking-kd-list");
        container.html('<div class="loading-spinner"><i class="fas fa-circle-notch"></i></div>');

        postNUI("getClassementKd").done(function (data) {
            container.empty();

            if (!data || data.length === 0) {
                container.html(
                    '<div class="lobby-empty"><i class="fas fa-chart-line"></i><span>Aucun classement disponible</span></div>'
                );
                return;
            }

            container.append(`
                <div class="ranking-header">
                    <span class="rh-pos">#</span>
                    <span class="rh-medal"></span>
                    <span class="rh-name">Joueur</span>
                    <span class="rh-stat">K/D</span>
                    <span class="rh-label">Kills</span>
                    <span class="rh-label">Deaths</span>
                </div>
            `);

            data.forEach(function (player, index) {
                const pos = index + 1;
                const medal = getMedal(pos);
                const topClass = getTopClass(pos);

                container.append(`
                    <div class="ranking-row ${topClass}">
                        <div class="ranking-position">${pos}</div>
                        <div class="ranking-medal">${medal}</div>
                        <div class="ranking-name">${player.playerName}</div>
                        <div class="ranking-stat">${player.kd}</div>
                        <div class="ranking-kd-stat">${formatNumber(player.kills)}</div>
                        <div class="ranking-kd-stat">${formatNumber(player.deaths)}</div>
                    </div>
                `);
            });
        });
    }

    function formatNumber(num) {
        if (!num) return "0";
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
});
