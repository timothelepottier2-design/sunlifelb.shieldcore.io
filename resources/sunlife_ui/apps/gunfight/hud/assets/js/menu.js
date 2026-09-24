$(document).ready(function () {
    // Mouse Controls
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var cursor = $('#cursorPointer');
    var cursorX = documentWidth / 2;
    var cursorY = documentHeight / 2;
    var idEnt = 0;

    function UpdateCursorPos() {
        $('#cursorPointer').css('left', cursorX);
        $('#cursorPointer').css('top', cursorY);
    }

    function triggerClick(x, y) {
        var element = $(document.elementFromPoint(x, y));
        element.focus().click();
        return true;
    }

    // Listen for NUI Events
    window.addEventListener('message', function (event) {
        // Crosshair
        if (event.data.crosshair == true) {
            $(".crosshair").addClass('fadeIn');
            // $("#cursorPointer").css("display","block");
        }
        if (event.data.crosshair == false) {
            $(".crosshair").removeClass('fadeIn');
            // $("#cursorPointer").css("display","none");
        }

        /*
            login = [
                {
                    title: "Patch Note 1",
                    description: "Fbznfbizubfbeiuiufzbf"
                },
                {
                    title: "Patch Note 2",
                    description: "Fbznfbizubfbeiuiufzbf"
                },
            ]

            lua 

            login = [
                {
                    title: "Patch Note 1",
                    description: "Fbznfbizubfbeiuiufzbf"
                },
                {
                    title: "Patch Note 2",
                    description: "Fbznfbizubfbeiuiufzbf"
                },
            ]

            login = {
                {
                    title = "Patch Note 1",
                    description = "Fbznfbizubfbeiuiufzbf"
                },
                {
                    title = "Patch Note 2",
                    description = "Fbznfbizubfbeiuiufzbf"
                },
            }
        */

        if (event.data.type === "staffinfo") {
            const staffdata = event.data

            if (staffdata.toggle) {
                $(".staffinfo").css("display", "block");
            } else {
                $(".staffinfo").css("display", "none");
            }

            // if (staffdata.players) {
                $("#si-player").empty() // Clears user-menu the list
                $("#si-player").append(`${staffdata.players}`);
            // } else if (staffdata.staffs) {
                $("#si-staffs").empty() // Clears user-menu the list
                $("#si-staffs").append(`${staffdata.staffs}`);
            // } else if (staffdata.staffsService) {
                $("#si-staffs-service").empty() // Clears user-menu the list
                $("#si-staffs-service").append(`(${staffdata.staffsService} en service)`);
            // } else if (staffdata.reports) {
                $("#si-reports").empty() // Clears user-menu the list
                $("#si-reports").append(`${staffdata.reports}`);
            // } else if (staffdata.reportsWait) {
                $("#si-reports-wait").empty() // Clears user-menu the list
                $("#si-reports-wait").append(`(${staffdata.reportsWait} en attente)`);

                $("#si-lspd").empty() // Clears user-menu the list
                $("#si-lspd").append(`${staffdata.copCount}`);

                $("#si-ems").empty() // Clears user-menu the list
                $("#si-ems").append(`${staffdata.emsCount}`);

                $("#si-pic").empty() // Clears user-menu the list
                $("#si-pic").append(`${staffdata.picCount}`);
            // }
        }

        if (event.data.type === "gunfightinfo") {
            const d = event.data;

            if (d.toggle) {
                $(".gf-hud-cod").css("display", "flex");
            } else {
                $(".gf-hud-cod").css("display", "none");
            }

            let kda = d.myKda;
            if (kda === null || kda === undefined || kda < 0) kda = 0.0;
            kda = parseFloat(kda).toFixed(2);

            $("#gf-player-count").text(d.players || 0);
            $("#gf-kills").text(d.myKills || 0);
            $("#gf-deaths").text(d.myDeaths || 0);
            $("#gf-kd").text(kda);
            if (d.lobbyName) {
                $("#gf-lobby-name").text(d.lobbyName);
            }
        }

        if (event.data.type === "login") {
            // document.getElementById("login").style.display = "block";
            $(".login").css("display", "block");
            document.getElementById("hud").style.backgroundColor = "#8869f75e";

            document.getElementById("microOff").style.display = "none";
            document.getElementById("radioImg").style.display = "none";
            document.getElementById("pressKey").style.display = "none";

            $(".element-1").css("opacity", "0");
            $(".element-2").css("opacity", "0");

            $("#container").hide();

            const login = event.data.patchnote
            login.forEach(button => {
                $(".infos").append(`<div class="patch-note-element"><div class="pne"><div class="pne-1"></div><p class="pne-t-1">${button.title}</p></div><div class="pne"><img class="pne-2" src="assets/images/arrow2.png"><p class="pne-t-2">${button.description}</p></div></div>`);
            });
        }

        if (event.data.type === "reward") {
            // document.getElementById("login").style.display = "block";
            $(".reward").css("display", "block");
            document.getElementById("hud").style.backgroundColor = "#8869f75e";

            document.getElementById("microOff").style.display = "none";
            document.getElementById("radioImg").style.display = "none";
            document.getElementById("pressKey").style.display = "none";

            // document.getElementById("online").innerHTML = onlineCount;

            $(".element-1").css("opacity", "0");
            $(".element-2").css("opacity", "0");

            $("#container").hide();

            const rewardlist = event.data.rewardlist
            rewardlist.forEach(button => {
                $(".reward-buttons").append(`
                    <div class=${button.retired == true ? "reward-button-active" : "reward-button"}>
                        ${ button.retired == true ? `
                        <div class="reward-retired">
                            <img style="height: 20px; width: 20px" src="https://cdn.discordapp.com/attachments/904727825699962940/928211729429721149/check.png" />
                            <p style="font-family: 'Bourgeois-BoldCondensed'; font-size: 0.6vw; color: #fff;">RETIRÉ</p>
                        </div>` : ``}          

                        <div class="reward-title">${button.title}</div>
                    
                        <div class="reward-contents">${button.amount}$</div>
                        <div class="reward-contents">
                            <img class="reward-vip" src="https://cdn.discordapp.com/attachments/904727825699962940/928208962652872734/VIP.png" />
                            ${button.amountVip}$
                        </div>
                    </div>
                `);
            });
        }


        $(".button").on("click", function () {

            document.getElementById("microOff").style.display = "block";
            document.getElementById("radioImg").style.display = "block";
            document.getElementById("pressKey").style.display = "block";

            $(".element-1").css("opacity", "100");
            $(".element-2").css("opacity", "100");

            $("#container").show();

            $(".login").css("display", "none");
            document.getElementById("hud").style.backgroundColor = "transparent";
            $.post('https://sunlife_ui/gunfight/disablenuifocus', JSON.stringify({
                nuifocus: false
            }));
        });

        // Menu
        if (event.data.menu == 'vehicle') {
            $(".menu-car").empty() // Clears user-menu the list

            let buttons = JSON.parse(event.data.buttons); // Retrieve buttons and parse it

            $(".crosshair").addClass('active');
            $(".menu-car").addClass('fadeIn');
            idEnt = event.data.idEntity;
            // $("#cursorPointer").css("display","none");

            // Append to the list
            buttons.forEach(button => {
                $(".menu-car").append(`<li><a class="${button.name}" href=""><span class="emoji"><img src="assets/images/${button.imgName}"></span><span class="text">${button.value}</span></a></li>`);
                $(`.${button.name}`).on('click', function (e) {
                    e.preventDefault();
                    $.post(`http://zCore/${button.event}`, JSON.stringify({
                        id: idEnt,
                        plate: button.plate
                    }));

                    $(".crosshair").removeClass('fadeIn').removeClass('active');
                    $(".menu").removeClass('fadeIn');
                    $.post('https://sunlife_ui/gunfight/disablenuifocus', JSON.stringify({
                        nuifocus: false
                    }));
                    // $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le coffre' ? 'Fermer le coffre' : 'Ouvrir le coffre');
                });
            });
        }
        if (event.data.menu == 'user') {
            $(".menu-user").empty() // Clears user-menu the list

            let buttons = JSON.parse(event.data.buttons); // Retrieve buttons and parse it

            $(".crosshair").addClass('active');
            $(".menu-user").addClass('fadeIn');
            idEnt = event.data.idEntity;
            // $("#cursorPointer").css("display","none");

            // Append to the list
            buttons.forEach(button => {
                $(".menu-user").append(`<li><a class="${button.name}" href=""><span class="emoji"><img src="assets/images/${button.imgName}"></span><span class="text">${button.value}</span></a></li>`);
                $(`.${button.name}`).on('click', function (e) {
                    e.preventDefault();
                    $.post(`https://sunlife_ui/gunfight/${button.event}`, JSON.stringify({
                        id: idEnt
                    }));
                    // $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le coffre' ? 'Fermer le coffre' : 'Ouvrir le coffre');
                });
            });
        }
        if ((event.data.menu == false)) {
            $(".crosshair").removeClass('active');
            $(".menu").removeClass('fadeIn');
            idEnt = 0;
        }

        // Click
        if (event.data.type == "click") {
            triggerClick(cursorX - 1, cursorY - 1);
        }
    });

    // Mousemove
    $(document).mousemove(function (event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    // Click Menu

    // Functions
    // Vehicle
    $('.openCoffre').on('click', function (e) {
        e.preventDefault();
        $.post('https://sunlife_ui/gunfight/togglecoffre', JSON.stringify({
            id: idEnt
        }));
        $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le coffre' ? 'Fermer le coffre' : 'Ouvrir le coffre');
    });

    $('.openCapot').on('click', function (e) {
        e.preventDefault();
        $.post('https://sunlife_ui/gunfight/togglecapot', JSON.stringify({
            id: idEnt
        }));
        $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le capot' ? 'Fermer le capot' : 'Ouvrir le capot');
    });

    $('.lock').on('click', function (e) {
        e.preventDefault();
        $.post('https://sunlife_ui/gunfight/togglelock', JSON.stringify({
            id: idEnt
        }));
        $(this).find('.text').text($(this).find('.text').text() == 'Verrouiller' ? 'Déverouiller' : 'Verrouiller');
    });

    // Functions
    // User
    $('.cheer').on('click', function (e) {
        e.preventDefault();
        $.post('https://sunlife_ui/gunfight/cheer', JSON.stringify({
            id: idEnt
        }));
    });


    // Click Crosshair
    $('.crosshair').on('click', function (e) {
        e.preventDefault();
        $(".crosshair").removeClass('fadeIn').removeClass('active');
        $(".menu").removeClass('fadeIn');
        $.post('https://sunlife_ui/gunfight/disablenuifocus', JSON.stringify({
            nuifocus: false
        }));
    });

    /*
    1 = Left   Mousebutton
    2 = Centre Mousebutton
    3 = Right  Mousebutton
    */

    // $(document).mousedown(function(e) {
    //     if (e.which === 1 || e.which === 2 || e.which === 3) {
    //         $(".crosshair").removeClass('fadeIn').removeClass('active');
    //         $(".menu").removeClass('fadeIn');
    //         $.post('https://sunlife_ui/gunfight/disablenuifocus', JSON.stringify({
    //             nuifocus: false
    //         }));
    //     }
    // });

    $(document).keypress(function (e) {
        if (e.which == 101) { // if "E" is pressed
            $(".crosshair").removeClass('fadeIn').removeClass('active');
            $(".menu").removeClass('fadeIn');
            $.post('https://sunlife_ui/gunfight/disablenuifocus', JSON.stringify({
                nuifocus: false
            }));
        }
    });

});
