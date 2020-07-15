/*=========================================================================================
    File Name: copy-to-clipboard.js
    Description: Copy to clipboard
    --------------------------------------------------------------------------------------
    Item Name: Vuexy  - Vuejs, HTML & Laravel Admin Dashboard Template
    Author: PIXINVENT
    Author URL: http://www.themeforest.net/user/pixinvent
==========================================================================================*/

var userText = $(".copy-to-clipboard-input");
var btnCopy = $(".copy-btn");

// copy text on click
btnCopy.on("click", function () {
  $(this).siblings(userText).select();
  document.execCommand("copy");
})
