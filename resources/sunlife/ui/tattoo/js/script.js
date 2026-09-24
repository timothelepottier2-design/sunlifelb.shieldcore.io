// ============================================================
// Tattooshop NUI (rg_core)
// Version self-service simplifiée : pas de management/business,
// callbacks préfixés "tattoo_" pour cohabiter avec le NUI de rg_core.
// ============================================================

var translation = {
    currency: "$",
    menu_header: "BOUTIQUE DE TATOUAGE",
    collection: "Collection {0}",
};

String.prototype.format = function () {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp("\\{" + i + "\\}", "gi");
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

var clientIsFemale = false;
var tattooList = {};
var categories = null;
var selectedCategory = null;
var selectedTattoo = null;
var currentType = null;
var catNumber = 0;
var currentMenu = null;

var PARENT_RESOURCE = (typeof GetParentResourceName === "function")
    ? GetParentResourceName()
    : (window.location.host || "rg_core");

function postParent(path, data) {
    var url = "https://" + PARENT_RESOURCE + "/" + path;
    if (data !== undefined) {
        $.post(url, JSON.stringify(data));
    } else {
        $.post(url, "{}");
    }
}

window.addEventListener("load", function () {
    postParent("tattoo_loaded");
});

window.addEventListener("message", function (event) {
    var item = event.data;
    if (!item || !item.action) return;

    switch (item.action) {
        case "loaded":
            $("#tattooshop .headerName").text(translation.menu_header);
            break;

        case "showTattooshopMenu":
            categories = item.categories;
            clientIsFemale = item.isFemale;
            tattooList = item.TattooList;
            loadCategories();
            currentMenu = "tattooshop";
            $("#tattooshop").css("display", "flex");
            break;

        case "hideTattooshopMenu":
            currentMenu = null;
            $("#tattooshop").addClass("hide");
            $("#tattooshop").fadeOut(150, function () {
                $(this).removeClass("hide");
                $(".optionsCircle").empty();
                $("#panelInside").empty();
                selectedCategory = null;
                selectedTattoo = null;
                currentType = null;
            });
            break;

        case "updateTattooshop":
            if (item.TattooList) {
                tattooList = item.TattooList;
                if (item.collection) {
                    loadCategory(item.collection, catNumber);
                }
            }
            break;

        case "openAgain":
            $("#tattooshop").css("display", "flex");
            break;
    }
});

$("#hide").click(function () {
    postParent("tattoo_hide");
    $(".optionsCircle").empty();
    $("#panelInside").empty();
});

$(document).on("click", "#remove", function () {
    postParent("tattoo_remove", {
        collection: $(this).data("collection"),
        id: $(this).data("tattooid"),
    });
});

$(document).on("click", "#buy", function () {
    postParent("tattoo_buy", {
        collection: $(this).data("collection"),
        id: $(this).data("tattooid"),
    });
});

$(document).on("click", "#show", function () {
    if (selectedTattoo && JSON.stringify(selectedTattoo) === JSON.stringify($(this))) {
        postParent("tattoo_reloadThis", {
            item: $(this).data("tattooid"),
            collection: $(this).data("collection"),
        });
        return;
    }
    if (selectedTattoo) {
        $(selectedTattoo).removeClass("tattoo-selected");
    }
    selectedTattoo = $(this);
    $(selectedTattoo).addClass("tattoo-selected");
    postParent("tattoo_change", {
        item: $(this).data("tattooid"),
        collection: $(this).data("collection"),
    });
});

function loadCategory(typeDlc, numberOfSelected) {
    var scrollHeight = null;
    if (currentType === typeDlc) {
        scrollHeight = $("#tattooshop .tattoos-list-bg").scrollTop();
    }

    currentType = typeDlc;
    catNumber = numberOfSelected;

    postParent("tattoo_switchCategory");

    $("#panelInside").empty();
    $("#panelInside").html(
        '<div>' +
        '<div class="tattoos-list-bg">' +
        '<div class="tattoos-list">' +
        '<div><div class="tattoosCategories"></div></div>' +
        '</div></div></div>'
    );

    if (!tattooList[typeDlc]) return;

    for (var key in tattooList[typeDlc]) {
        if (!Object.prototype.hasOwnProperty.call(tattooList[typeDlc], key)) continue;
        var value = tattooList[typeDlc][key];
        if ((!clientIsFemale && value.nameHashMale) || (clientIsFemale && value.nameHashFemale)) {
            var itemPrice = value.hasTattoo ? value.removePrice : value.price;
            var html = '' +
                '<div class="tattoo">' +
                '<div class="label">' +
                '<p>' + (value.label || "") + '</p>' +
                '<div><div class="options">' +
                '<div class="price"><p>$' + itemPrice + '</p></div>';

            if (value.hasTattoo) {
                html += '<div id="remove" data-tattooid="' + key + '" data-collection="' + typeDlc + '">' +
                    '<i class="fa-solid fa-trash"></i></div>';
            } else {
                html += '<div id="buy" data-tattooid="' + key + '" data-collection="' + typeDlc + '">' +
                    '<i class="fa-solid fa-dollar-sign"></i></div>';
            }

            html += '<div id="show" data-tattooid="' + key + '" data-collection="' + typeDlc + '">' +
                '<i class="fa-solid fa-eye"></i></div>' +
                '</div></div></div>';

            $(".tattoosCategories").append(html);
        }
    }

    if (scrollHeight) {
        $("#tattooshop .tattoos-list-bg").scrollTop(scrollHeight);
    }
    if (selectedTattoo) {
        $(selectedTattoo).addClass("tattoo-selected");
    }
}

function loadCategories() {
    if (!categories) return;
    var labels = {
        1: "mpbusiness_overlays", 2: "mphipster_overlays", 3: "mpbiker_overlays",
        4: "mpairraces_overlays", 5: "mpbeach_overlays", 6: "mpchristmas2_overlays",
        7: "mpgunrunning_overlays", 8: "mpimportexport_overlays", 9: "mplowrider2_overlays",
        10: "mplowrider_overlays", 11: "mpchristmas2017_overlays", 12: "mpheist3_overlays",
        13: "mpheist4_overlays", 14: "mpluxe_overlays", 15: "mpluxe2_overlays",
        16: "mpsecurity_overlays", 17: "mpsmuggler_overlays", 18: "mpstunt_overlays",
        19: "mpsum2_overlays", 20: "mpvinewood_overlays", 21: "vms_overlays",
        22: "multiplayer_overlays",
    };
    $(".optionsCircle").empty();
    var firstNum = null;
    for (var i = 1; i <= 22; i++) {
        if (categories[String(i)]) {
            if (firstNum === null) firstNum = i;
            $(".optionsCircle").append(
                '<div class="itemCircle" data-type="' + labels[i] + '" data-number="' + i + '"><p>' + i + '</p></div>'
            );
        }
    }
    $(".itemCircle").click(function () {
        if (selectedCategory) {
            $(selectedCategory).removeClass("category-selected");
        }
        selectedCategory = $(this);
        $(selectedCategory).addClass("category-selected");
        var type = $(this).data("type");
        catNumber = $(this).data("number");
        selectedTattoo = null;
        loadCategory(type, catNumber);
    });

    // Auto-sélectionne la première catégorie disponible pour afficher
    // immédiatement la liste de tatouages.
    if (firstNum !== null) {
        var $first = $('.itemCircle[data-number="' + firstNum + '"]');
        if ($first.length) {
            selectedCategory = $first;
            $first.addClass("category-selected");
            loadCategory(labels[firstNum], firstNum);
        }
    }
}

$(document).on("keydown", "body", function (e) {
    if (e.which === 27 && currentMenu === "tattooshop") {
        postParent("tattoo_hide");
    }
});
