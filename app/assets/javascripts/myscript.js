$(document).ready(function () {
  $("#sportstable").DataTable({ info: false });
});

$(document).ready(function () {
  $("#poststable").DataTable({
    //  "bPaginate": false
    info: false,
  });
});

$(document).ready(function () {
  $(".js-example-basic-single").select2();
});

// $(function () {
//   var $registrationform = $("#myform");
//   if ($registrationform.length) {
//     $registrationform.validate({
//       rules: {
//         name: {
//           required: true,
//           minlength: 4,
//         },
//       },
//     });
//   }
// });
