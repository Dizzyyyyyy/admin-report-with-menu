$(function () {
    let players = [];
    const listdata = [{value: "1", text: "Something went wrong. Please contact development."}];
    const datalist = new DataList(
        "datalist",
        "datalist-input",
        "datalist-ul",
        listdata
    );
    datalist.create();
    datalist.addListeners(datalist);

    function display(bool) {
        if (bool) {
            $(".container").show();
            $("#datalist-input").val(""); // Clear all values
            $("#reason").val("");
            $("#datalist").removeClass("active");
            $("#submit").html("Submit");
            $("p#error").html("")
            $("#datalist-input").removeClass("error");
            $("#reason").removeClass("error");
            datalist.create()
        } else {
            $(".container").hide();
        }
    }

    display(false);

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        } else if (item.type === "Players") {
            if (item.data) {
                players = JSON.parse(item.data);
                let data = [];
                for (let i=0; i<players.length; i++) {
                    data.push({value: i+1,text: players[i].id + " " + players[i].name, })
                }
                datalist.update(data, $("#datalist-input").val());
            }
        } else if (item.type === "Show") {
            if (item.data) {
                values = JSON.parse(item.data);
                $("#datalist-input").val(values.pid)
                $("#reason").val(values.reason.trim())
                datalist.create(values.pid.toLowerCase());
            }
        }
    })
    // Keyboard Logic
    document.onkeyup = function (key) {
        if (key.which == 27) { // ESC (close menu)
            $.post('http://report-system/exit', JSON.stringify({}));
            return
        }
    };

    // Close Button 
    $("#close").click(function () {
        $.post('http://report-system/exit', JSON.stringify({}));
        return
    })

    // Submit Logic
    $("#submit").click(function () {
        $("#submit").html('<i class="fa fa-circle-o-notch fa-spin"></i> Creating...')
        let pId = $("#datalist-input").val().split(" ")[0];
        let player = players.find(plr => plr.id === parseInt(pId));
        let reason = $("#reason").val();
        setTimeout(() => {
            if (player == undefined) {
                $("#submit").html("Submit");
                $("#datalist-input").addClass("error");
                $("p#error").html("Please enter a valid Player ID.")
            } else if (reason === "") {
                $("#submit").html("Submit");
                $("#reason").addClass("error");
                $("#datalist-input").removeClass("error");
                $("p#error").html("Please enter the reason for your report.")
            } else {
                pName = player.name;
                $.post('http://report-system/success', JSON.stringify({id: pId, name: pName, reason: reason}));
            }
        }, 500)
    })
})