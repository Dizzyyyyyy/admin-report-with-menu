class DataList {
    constructor(containerId, inputId, listId, options) {
        this.containerId = containerId;
        this.inputId = inputId;
        this.listId = listId;
        this.options = options;
    }

    create(filter = "") {
        const list = document.getElementById(this.listId);
        const filterOptions = this.options.filter(
            d => filter === "" || d.text.toLowerCase().includes(filter)
        );

        if (filterOptions.length === 0) {
            list.classList.remove("active");
        } else {
            list.classList.add("active");
        }

        list.innerHTML = filterOptions
            .map(o => `<li id=${o.value}>${o.text}</li>`)
            .join("");
    }

    update(data, inp) {
        this.options = data;
        this.create(inp.toLowerCase());
    }

    addListeners(datalist) {
        const container = document.getElementById(this.containerId);
        const input = document.getElementById(this.inputId);
        const list = document.getElementById(this.listId);
        input.addEventListener("focus", e => {
            if (e.target.id === this.inputId) {
                container.classList.add("active");
            } else if (e.target.id === "datalist-icon") {
                container.classList.add("active");
                input.focus();
            }
        });

        document.addEventListener("click", e => {
            if(e.target != input && e.target.nodeName.toLocaleLowerCase() != "li") {
                container.classList.remove("active");
            } else {
                //input.focus();
            }
        });

        input.addEventListener("input", function(e) {
            if (!container.classList.contains("active")) {
                container.classList.add("active");
            }

            datalist.create(input.value.toLowerCase());
        });

        list.addEventListener("click", function(e) {
            if (e.target.nodeName.toLocaleLowerCase() === "li") {
                input.value = e.target.innerText;
				container.classList.remove("active");
            }
        });
    }
}