$(document).on('turbolinks:load', function() {
  // Close Popup Modal
  $('.modal-close-btn').click(function() {
    $(this).parent().parent().modal('hide');
  });

  console.log("IN FIle");

  $('.challenge-submission-btn').click(function () {
   console.log("IN CLick")
  });


  $('body').on('click', '.challenge-submission-btn', function (e) {
    console.log("ININININNI");
    var challengeId = $(this).data('challenge-id');

    $.ajax({
      type: 'GET',
      url: "/challenges/" + challengeId
    });
  });
});
