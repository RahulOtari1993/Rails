// datatable
$(document).ready(function () {
  $("#sportstable").DataTable({ info: false });
});

$(document).ready(function () {
  $("#poststable").DataTable({
    //  "bPaginate": false
    info: false,
  });
});

// select2 for drop down
$(document).ready(function () {
  $(".js-example-basic-single").select2();
});

// front end validation for player table
$(function () {
  var $registrationform = $("#playerValidate");
  if ($registrationform.length) {
    $registrationform.validate({
      rules: {
        "player[player_name]": {
          required: true,
        },
        "player[email]": {
          required: true,
          minlength: 4,
        },
        "player[player_city]": {
          required: true,
          minlength: 4,
        },
        "player[player_state]": {
          required: true,
          minlength: 4,
        },
        "player[player_country]": {
          required: true,
          minlength: 4,
        },
        "player[phone]": {
          required: true,
          minlength: 10,
        },
      },
    });
  }
});

// front end validation for player table
