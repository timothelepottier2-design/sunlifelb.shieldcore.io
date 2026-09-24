// Dialogue de saisie historique.
//
// Il basculait `document.body`, ce qui masquait TOUTE la page. Depuis que
// l'overlay Zone AFK partage cette même page NUI, il bascule son propre
// conteneur `#legacy-input-root` — comportement identique, mais sans emporter
// l'autre overlay avec lui.
$(() => {
    const input = document.getElementById("input");
    const root = document.getElementById("legacy-input-root");

    window.addEventListener('message', (e) => {
        if (e.data.type === "enableui") {
            root.style.display = e.data.enable ? "block" : "none";
            $("#title").text(e.data.title);
            $("input").focus();
        }
    })

    input.addEventListener("keyup", (e) => {
        if (e.keyCode === 13) {
            const v = $("input").val()

            $.post("http://xnlrankbar/sumbit", JSON.stringify(v))
            $('#input').val('');
            root.style.display = "none";
        }

        if (e.keyCode === 27) {
            const v = $("input").val()

            $.post("http://xnlrankbar/cancel", JSON.stringify(""))
            $('#input').val('');
            root.style.display = "none";
        }
    })

})