// ==UserScript==
// @name         oghma email change type
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       fta
// @match        https://oghma.epcc.pt/login
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function() {
    document.getElementById("user_email").type = 'text';
})();
