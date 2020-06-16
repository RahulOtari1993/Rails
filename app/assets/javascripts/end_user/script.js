$(document).on('turbolinks:load', function () {
  // Close Popup Modal
  $('.modal-close-btn').click(function () {
    $(this).parent().parent().modal('hide');
  });

  // Open Challenge Sumission Modal Popup
  $('body').on('click', '.challenge-submission-btn', function (e) {
    var challengeId = $(this).data('challenge-id');

    $.ajax({
      type: 'GET',
      url: `/participants/challenges/${challengeId}/details`
    });
  });

  // Trigger SWAL Notificaton
  function swalNotify(title, message) {
    Swal.fire({
      title: title,
      text: message,
      confirmButtonClass: 'btn btn-primary',
      buttonsStyling: false,
    });
  }

  // Submit Visit a URL Challenge
  $('.challenge-submission-modal').on('click', '.submit-link-challenge', function (e) {
    var challengeId = $(this).data('challenge-id');
    var _this = $(this);

    $.ajax({
      type: 'POST',
      url: `/participants/challenges/${challengeId}/submission`,
      data: {
        authenticity_token: $('[name="csrf-token"]')[0].content,
      },
      success: function (data) {
        if (data.success) {
          // Display Challenge Completion Message
          $('.challenge-completion-container').show();
          _this.hide();
        } else {
          swalNotify('CHallenge Submission', data.message);
        }
      }
    });
  });
});
