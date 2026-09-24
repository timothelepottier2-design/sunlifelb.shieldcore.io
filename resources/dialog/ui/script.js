$(() => {
    const input = document.getElementById("input");

    window.addEventListener('message', (e) => {
        if (e.data.type === "enableui") {
            document.body.style.display = e.data.enable ? "block" : "none";
            $("p").text(e.data.title);
            $("input").focus();
        }
    })

    input.addEventListener("keyup", (e) => {
        if (e.keyCode === 13) {
            const v = $("input").val()

            $.post("http://dialog/sumbit", JSON.stringify(v))
            $('#input').val('');
            document.body.style.display = "none";
        }

        if (e.keyCode === 27) {
            const v = $("input").val()

            $.post("http://dialog/cancel", JSON.stringify(""))
            $('#input').val('');
            document.body.style.display = "none";
        }
    })

})