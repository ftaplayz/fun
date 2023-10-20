// ==UserScript==
// @name         person find
// @version      1
// @description  encontra nomes no oghma
// @author       fta
// @match        https://oghma.epcc.pt/courses/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    var estudantes = document.getElementsByClassName("student");
    var regex = /(https:\/\/oghma.epcc.pt\/courses\/)(\d+)(\/.+)/;
    var turma = Number(location.href.replace(regex, "$2"));

    if (localStorage.nomeSearch)
        procurarPessoa();
    else
        localStorage.setItem("nomeSearch", "");

    var botao = document.getElementsByClassName('add-on')[0];
    //botao.appendChild(document.createTextNode("Search"));
    botao.style.cursor = 'pointer';
    botao.onclick = function () {
        localStorage.nomeSearch = prompt("Nome a procurar?")
        procurarPessoa();
    };
    //document.body.appendChild(botao);

    function procurarPessoa() {
        if (turma > 1) {
            if (localStorage.nomeSearch != "null" && localStorage.nomeSearch != "") {
                var nomeAtual = "";
                var nP = new RegExp(localStorage.nomeSearch, "i");
                var existe = false;
                for (var i = 0; i < estudantes.length; i++) {
                    if (estudantes[i].childNodes[6].innerText != undefined)
                        nomeAtual = estudantes[i].childNodes[6].innerText;
                    else
                        continue;
                    if (nP.test(nomeAtual)) {
                        existe = true;
                        break;
                    } else
                        existe = false;
                }
                if (existe) {
                    localStorage.nomeSearch = "";
                    alert("Encontrado!");
                } else
                    location.replace("https://oghma.epcc.pt/courses/" + (--turma) + "/subscriptions");
            }
        } else
            localStorage.nomeSearch = "";
    }

})();
