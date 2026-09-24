$(function () {
  window.addEventListener("message", function (event) {
    var mess = event.data;
    if (mess) {

      if (mess.type === "joindiscord") {
        window.invokeNative('openUrl', 'https://discord.gg/alyniarp');
      }
      
      if (mess.type === "openshop") {
        window.invokeNative('openUrl', 'https://shop.alyniarp.fr');
      }

      if (mess.type === "openrules") {
        window.invokeNative('openUrl', 'https://sites.google.com/view/alyniarp/r%C3%A8glement-global');
      }

      if (mess.type === "votePage") {
        window.invokeNative('openUrl', 'https://top-serveurs.net/gta/vote/fa-alyniarp-500-slots-90-fps-rp-serieux-pnj-radio-dlc-the-criminal-entreprises?pseudo=' + mess.code);
      }

      if (mess.type === "propsPage") {
        window.invokeNative('openUrl', 'https://gtahash.ru/');
      }

      if (mess.type === "topRight") {
        setCurrentId(mess.serverId);
        setCurrentOnlineCount(mess.onlineCount);
        setCurrentHour();
      }

      if (mess.type === "micEnabled") {
        playerIsTalking();
      }

      if (mess.type === "micDisabled") {
        playerStoppedTalking();
      }

      if (mess.type === "radioButtonEnabled") {
        showRadioIcon();
      }

      if (mess.type === "radioButtonDisabled") {
        hideRadioIcon();
      }

      if (mess.type === "radioEnabled") {
        playerIsTalkingInRadio();
      }

      if (mess.type === "radioDisabled") {
        playerStoppedTalkingInRadio();
      }

      if (mess.type === "safeZoneEntered") {
        playerEnteredSafeZone();
      }

      if (mess.type === "weaponBlocked") {
        playerWeaponBlocked();
      }

      if (mess.type === "showInteraction") {
        showInteraction(mess.key, mess.message);
      }

      if (mess.type === "radioTalkers") {
        setRadioTalkers(mess.talkers);
      }

      if (mess.type === "displayComa") {
        displayComa();
        hideHud();
      }

      if (mess.type === "hideComa") {
        setComaFirst("10:00");
        setComaTwo("EN ATTENTE D'AIDE");
        setComaTree("AVANT DE MOURIR");

        hideComa();
        // showHud();
      }

      if (mess.type === "comaTime") {
        setComaFirst(mess.time);
      }

      if (mess.type === "cooldownCall") {
        setTimePercentage(mess.count);
      }

      if (mess.type === "enableCallButton") {
        setAmbulanceClickable(true);
      }

      if (mess.type === "showHospital") {
        showReturnToHospital();
      }

      if (mess.type === "hideHospital") {
        hideReturnToHospital();
      }

      if (mess.type === "editFirstComa") {
        setComaFirst(mess.text);
      }

      if (mess.type === "editTwoComa") {
        setComaTwo(mess.text);
      }

      if (mess.type === "editTreeComa") {
        setComaTree(mess.text);
      }

      if (mess.type === "editComing") {
        setComing(mess.text);
      }

      if (mess.type === "hunger") {
        setFoodLevel(mess.count);
      }

      if (mess.type === "thirst") {
        setThirstLevel(mess.count);
      }

      if (mess.type === "hideAll") {
        // console.log("hideAll");
        hideHud();
      }

      if (mess.type === "showAll") {
        // console.log("showAll");
        showHud();
      }

      if (mess.type === "toggleHunger") {
        toggleHunger();
      }

      if (mess.type === "toggleMic") {
        toggleMic();
      }

      if (mess.type === "toggleCoords") {
        toggleCoords();
      }

      if (mess.type === "toggleDiscord") {
        toggleDiscord();
      }

      if (mess.type === "showPurge") {
        showPurge();
        setPurgePrimeReward(15000);
        setCurrentPurgeCoinsBalance(6468);
        setPurgeDistance(137, true, true, true);
      }

      if (mess.type === "updatePurgeDistance") {
        setPurgeDistance(mess.dist, mess.rect1, mess.rect2, mess.rect3);
      }

      // setFoodLevel
      // setThirstLevel
    }
  });

  $("#safeZone").css("display", "none");
});

function formatNumber(num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}

/*
  Une fois call, l'hud disparaîtra (pour le mode cinématique par exemple ou pendant la mort)
*/
function hideHud() {
  setTimeout(() => {
    $("#hud").fadeOut();
  }, 500);

  // document.getElementById("hud").style.visibility = "hidden";
}

/*
  Une fois call, cette fonction ré affichera l'HUD (après un revive ou après désactivation du 
  mode cinématique par exemple).
*/
function showHud() {
  setTimeout(() => {
    $("#hud").fadeIn();
  }, 500);

  // document.getElementById("hud").style.visibility = "visible";
}

/*
  Une fois call (avec le paramètre correspondant qui est un nombre), ça changera le nombre
  de joueurs en lignes pour afficher celui fournit en paramètre
*/
function setCurrentOnlineCount(onlineCount) {
  document.getElementById("online").innerHTML = onlineCount;
}

/*
  Une fois call (avec le paramètre correspondant qui est un nombre), ça changera l'id du joueur
  pour afficher celui fournit en paramètre
*/
function setCurrentId(serverId) {
  document.getElementById("id").innerHTML = serverId;
}

function setCurrentHour() {
  const test = new Date();
  let hour = test.getHours();
  let min = test.getMinutes();

  if (hour.toString().length === 1) {
    hour = "0" + hour
  }
  if (min.toString().length === 1) {
    min = "0" + min
  }

  document.getElementById("hourReal").innerHTML = hour + ":" + min;
}

/*
  Une fois call, cette fonctoin permettra d'afficher le badge "Zone Safe" pendant 3.5 secondes
  avant de le re masquer.
*/
function playerEnteredSafeZone() {
  $("#safeZone").css("display", "block");
  $("#safeZone").addClass("fadeIn");
  setTimeout(() => {
    $("#safeZone").removeClass("fadeIn");
    $("#safeZone").fadeOut();
  }, 7 * 1000);
}

function playerWeaponBlocked() {
  $("#weaponBlocked").css("display", "block");
  $("#weaponBlocked").addClass("fadeIn");
  setTimeout(() => {
    $("#weaponBlocked").removeClass("fadeIn");
    $("#weaponBlocked").fadeOut();
  }, 7 * 1000);
}

/*
  Quand le joueur commence à parler tu appelles la fonction 
  une seule fois
*/
function playerIsTalking() {
  document.getElementById("microOff").src =
    "nui://sunlife_ui/apps/gunfight/hud/assets/images/mic_on.png";
  document.getElementById("microOff").style.opacity = "1";
  document.getElementById("microOff").style.marginLeft = "11px";
}

/*
  Quand le joueur arrête de parler tu appelles la fonction
  une seule fois
*/
function playerStoppedTalking() {
  document.getElementById("microOff").src =
    "nui://sunlife_ui/apps/gunfight/hud/assets/images/mic.png";
  document.getElementById("microOff").style.opacity = "0.35";
}

/*
  Quand le joueur commence à parler EN RADIO tu appelles la fonction 
  une seule fois
*/
function playerIsTalkingInRadio() {
  document.getElementById("radioImg").classList.remove("stoppedRadio");
  document.getElementById("radioImg").classList.add("activeRadio");
  document.getElementById("radioImg").style.filter =
    "drop-shadow(-2px 2px 20px #FFFFFF)";
}

/*
	Quand le joueur arrête de parler EN RADIO tu appelles la fonction
	une seule fois
*/
function playerStoppedTalkingInRadio() {
  document.getElementById("radioImg").classList.remove("activeRadio");
  document.getElementById("radioImg").classList.add("stoppedRadio");

  document.getElementById("radioImg").style.opacity = ".25";
  document.getElementById("radioImg").style.filter = "";
}

/*
Appelle cette fonction si tu veux afficher le truc
avec marqué [Touche] INTERACTION.

(t'es pas obligé de mettre de message, si t'en met un,
ca va changer le INTERACTION avec le message)

par exemple
showInteraction("E", "Traiter de la cocaïne");

ou alors
showInteraction("E") > ca affichera [E] INTERACTION
)
*/
var lastCallTime = 0;

function showInteraction(key, message) {
  document.getElementById("pressKey").style.display = "flex";
  document.getElementById("key").innerHTML = key;
  if (message) document.getElementById("interact").innerHTML = message;
  else document.getElementById("interact").innerHTML = "INTERACTION";

  lastCallTime = Date.now();
}


/*
  Quand le joueur équipe/allume sa radio (pour que l'icone apparaisse)
*/
function showRadioIcon() {
  document.getElementById("radioImg").style.visibility = "visible";
  document.getElementById("radioTalkers").style.visibility = "visible";
}

/*
  Quand le joueur dé-équipe/éteinds sa radio (pour que l'icone s'en aille)
*/
function hideRadioIcon() {
  document.getElementById("radioImg").style.visibility = "hidden";
  document.getElementById("radioTalkers").style.visibility = "hidden";
}

/*
Street Label (on touche pas)
Pas la peine de regarder t'as aucune fonction à call ici
*/
window.onload = (e) => {
  document.getElementById("radioImg").style.visibility = "hidden";
  document.getElementById("radioTalkers").style.visibility = "hidden";
  window.addEventListener("message", onMessageRecieved);
};

function onMessageRecieved(event) {
  let item = event.data;

  if (item && item.type === "streetLabel:MSG") {
    if (!item.active) {
      $("#container").hide();
    } else {
      $("#container").show();

      let direction = item.direction;
      let zone = item.zone;
      let street = item.street;

      $("#direction").text(direction);
      $("#zone").text(zone);
      $("#street").text(street);
    }
  }

  if (item && item.type === "streetLabel:DATA") {
    if (item.color) {
      $("#zone").css("color", item.color);
    }
    /* Position/Scale HUD according to configuration file */
    if (item.offsetX) {
      container.style.left = item.offsetX + "%";
    }
    if (item.offsetY) {
      container.style.bottom = item.offsetY + "%";
    }
    if (item.scale) {
      container.style.transform = `scale(${item.scale})`;
    }
  }
}

function setRadioTalkers(talkers) {
  if (!talkers) talkers = "";
  var array = talkers.split(";");

  var li = document.getElementById("talkersList");
  li.innerHTML = "";
  array.forEach((ar) => {
    if (ar.length == 0) return;
    li.innerHTML += `<li>${ar}</li>`;
  });
}

/*
  AJOUTS COMA
*/

/*
  Fonction à call pour faire appparaître l'écran de coma (à la mort du joueur)
*/
function displayComa() {
  setAmbulanceClickable(true);
  hideReturnToHospital();
  document.querySelector("#coma").style.display = "flex";
}

/*
  Fonction à call pour faire disparaître le coma (quand il est revive etc...)
*/
function hideComa() {
  document.querySelector("#coma").style.display = "none";
}

/*
  setAmbulanceClickable(true); => Le bouton devient clickable, le sablier disparaît
  setAmbulanceClickable(false); => Le bouton n'est plus cliquable, le sablier réapparaît
*/
function setAmbulanceClickable(clickable) {
  if (clickable) {
    document.querySelectorAll(".callAmbulance")[0].classList.remove("disabled");
    document.querySelectorAll(".remainingTime")[0].style.display = "none";
  } else {
    document.querySelectorAll(".callAmbulance")[0].classList.add("disabled");
    document.querySelectorAll(".remainingTime")[0].style.display = "flex";
  }
}

/*
	Fonction qui va afficher le bouton retourner à l'hôpital
*/
function showReturnToHospital() {
  document.querySelectorAll(".returnToHospital")[0].style.display = "flex";
}

/*
	Fonction qui va masquer le bouton retourner à l'hôpital
*/
function hideReturnToHospital() {
  document.querySelectorAll(".returnToHospital")[0].style.display = "none";
}

/*
	Permet de changer la première ligne du coma (Temps écoulé / En attente d'aide)
*/
function setComaFirst(text) {
  document.querySelector("#comaFirst").innerHTML = text;
}

/*
	Permet de changer la deuxieme ligne du coma (En attente d'aide / vous pouvez retourner)
*/
function setComaTwo(text) {
  document.querySelector("#comaSecond").innerHTML = text;
}

/*
	Permet de changer la troisième ligne du coma (Avant de mourir / A l'hopital)
*/
function setComaTree(text) {
  document.querySelector("#comaThird").innerHTML = text;
}

function setComing(text) {
  document.querySelector("#coming").innerHTML = text;
}

/*
	Permet de changer le temps affiché pour le sablier (en pourcentage)
*/
function setTimePercentage(percentage) {
  var n = parseInt(percentage);
  document.querySelector("#timePercentage").style.width = `${percentage}%`;
}

/*
    Quand le bouton pour retourner à l'hôpital est cliqué
*/
function hospitalClicked() {
  fetch(`https://sunlife_ui/gunfight/ui:clickedHospital`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({}),
  });
}
/*
    Quand le bouton pour appeler une ambulance est cliqué
*/
function ambulanceClicked() {
  setAmbulanceClickable(false);
  fetch(`https://sunlife_ui/gunfight/ui:clickedAmbulance`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({}),
  });
}

initButtons();

function initButtons() {
  document
    .querySelectorAll(".callAmbulance")[0]
    .addEventListener("click", () => {
      var ambuCall = document.querySelectorAll(".callAmbulance")[0];
      if (ambuCall.classList.contains("disabled")) return;
      ambulanceClicked();
    });

  document
    .querySelectorAll(".returnToHospital")[0]
    .addEventListener("click", () => {
      var ambuCall = document.querySelectorAll(".returnToHospital")[0];
      if (ambuCall.classList.contains("disabled")) return;
      hospitalClicked();
    });
}
/*
    Permet de définir le niveau de bouffe actuel (en fournissant un pourcentage)
    Attention ça doit être un nombre (ducoup sans le % à la fin)

*/
function setFoodLevel(percentage) {
  document.getElementById("foodBar").style.width = `${percentage}%`;
}
/*
    Permet de définir le niveau de soiffe actuel (en fournissant un pourcentage)
    Attention ça doit être un nombre (ducoup sans le % à la fin)

*/
function setThirstLevel(percentage) {
  document.getElementById("thirstBar").style.width = `${percentage}%`;
}

let hungerShowed = true;
function toggleHunger() {
  if (hungerShowed) {
    $(".stats").css("opacity", "0");
    hungerShowed = false;
  } else {
    $(".stats").css("opacity", "1");
    hungerShowed = true;
  }
}

let micShowed = true;
function toggleMic() {
  if (micShowed) {
    $(".e1-hud-bottom-b1-c2-top").css("opacity", "0");
    micShowed = false;
  } else {
    $(".e1-hud-bottom-b1-c2-top").css("opacity", "1");
    micShowed = true;
  }
}

let coordsShowed = true;
function toggleCoords() {
  if (coordsShowed) {
    $(".e1-hud-bottom-b1-c2-bottom").css("opacity", "0");
    coordsShowed = false;
  } else {
    $(".e1-hud-bottom-b1-c2-bottom").css("opacity", "1");
    coordsShowed = true;
  }
}

let discordShowed = true;
function toggleDiscord() {
  if (discordShowed) {
    $(".e3-hud-top-b1-c2").css("opacity", "0");
    discordShowed = false;
  } else {
    $(".e3-hud-top-b1-c2").css("opacity", "1");
    discordShowed = true;
  }
}

/**
 * Distance (Nombre) -> Distance en mètres
 * first (Boolean) -> True = Premier rectangle allumé / False => Éteint
 * second (Boolean) -> True = Second rectangle allumé / False => Éteint
 * third (Boolean) -> True = Troisième rectangle allumé / False => Éteint
 */
function setPurgeDistance(distance, first, second, third) {
  document.getElementById("distance").innerHTML = `(${distance}m)`;
  if (first)
    document.getElementsByClassName("helper").item(0).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(0)
      .classList.remove("active");

  if (second)
    document.getElementsByClassName("helper").item(1).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(1)
      .classList.remove("active");

  if (third)
    document.getElementsByClassName("helper").item(2).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(2)
      .classList.remove("active");
}

/*

    ######################################################
    ##                                                  ##
    ##             Fonctions concernant la              ##
    ##                      Purge                       ##
    ##                                                  ##
    ######################################################

*/

/**
 * price (Number) -> Pièces d'or à gagner pour la purge
 */
function setPurgePrimeReward(price) {
  document.getElementById("rewardPurge").innerHTML = formatNumber(price);
}

/**
 * balance (Number) -> Nombre de coin possédés par le joueur
 */
function setCurrentPurgeCoinsBalance(balance) {
  document.getElementById("currentBalance").innerHTML = formatNumber(balance);
}

/*
 * Tu connais hein, ça affiche la purge
 */
function showPurge() {
  document.getElementById("purge").style.display = "block";
  document.getElementsByClassName("purgecoins").item(0).style.display = "flex";
}

/*
 * Tu connais hein, ça masque la purge
 */
function hidePurge() {
  document.getElementById("purge").style.display = "none";
  document.getElementsByClassName("purgecoins").item(0).style.display = "none";
}

/**
 * Distance (Nombre) -> Distance en mètres
 * first (Boolean) -> True = Premier rectangle allumé / False => Éteint
 * second (Boolean) -> True = Second rectangle allumé / False => Éteint
 * third (Boolean) -> True = Troisième rectangle allumé / False => Éteint
 */
function setPurgeDistance(distance, first, second, third) {
  document.getElementById("distance").innerHTML = `(${distance}m)`;
  if (first)
    document.getElementsByClassName("helper").item(0).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(0)
      .classList.remove("active");

  if (second)
    document.getElementsByClassName("helper").item(1).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(1)
      .classList.remove("active");

  if (third)
    document.getElementsByClassName("helper").item(2).classList.add("active");
  else
    document
      .getElementsByClassName("helper")
      .item(2)
      .classList.remove("active");
}
