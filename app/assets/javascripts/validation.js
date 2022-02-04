$(document).ready(function () {
  $("#dropdown").select2();
});

$(document).ready(function () {
  $(".datepicker").datepicker();
});

$(function () {
  var $registrationform = $("#myform");
  if ($registrationform.length) {
    $registrationform.validate({
      rules: {
        firstname: {
          required: true,
          minlength: 4,
        },
        lastname: {
          required: true,
          minlength: 4,
        },
        age: {
          required: true,
        },
        phone: {
          required: true,
          digits: true,
          minlength: 10,
        },
        email: {
          required: true,
          minlength: 4,
        },
        url: {
          required: true,
          url: true,
        },
      },
    });
  }
});
