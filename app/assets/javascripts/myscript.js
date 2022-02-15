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
          minlength: 3,
        },
        "player[email]": {
          required: true,
          email: true,
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
          minlength: 3,
        },
        "player[phone]": {
          required: true,
          digits: true,
          minlength: 10,
          maxlength: 10,
        },
      },
    });
  }
});
// front end validation for sport table
$(function () {
  var $sportform = $("#sportValidate");
  if ($sportform.length) {
    $sportform.validate({
      rules: {
        "sport[sport_name]": {
          required: true,
          minlength: 3,
        },
        "sport[total_player]": {
          required: true,
          digits: true,
        },
      },
    });
  }
});
//front end validation for achievement table
$(function () {
  var $sportform = $("#achievemetValidate");
  if ($sportform.length) {
    $sportform.validate({
      rules: {
        "achievement[player]": {
          required: true,
          minlength: 3,
        },
        "achievement[award]": {
          required: true,
          minlength: 3,
        },
        "achievement[medal]": {
          required: true,
          minlength: 3,
        },
      },
    });
  }
});
//front end validation for post table
$(function () {
  var $sportform = $("#postValidate");
  if ($sportform.length) {
    $sportform.validate({
      rules: {
        "post[title]": {
          required: true,
          minlength: 3,
        },
        "post[playerName]": {
          required: true,
          minlength: 3,
        },
        "post[description]": {
          required: true,
          maxlength: 50,
        },
      },
    });
  }
});
//front end validation for comment table
$(function () {
  var $sportform = $("#commentValidate");
  if ($sportform.length) {
    $sportform.validate({
      rules: {
        "comment[comment]": {
          required: true,
        },
      },
    });
  }
});
