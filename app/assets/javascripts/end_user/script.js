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

  // Function for fetching particular URL Param
  function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');

      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
      }
    }
  };

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

  // Load Profile Onboarding Questions
  setTimeout(function () {
    var new_connect = getUrlParameter('c');

    if (typeof new_connect !== "undefined" && $('#onboarding_questions_modal').length > 0 ) {
      $('#onboarding_questions_modal').modal('show');
    }
  }, 2000);

  // Date Picker for Onboarding Questions
  $('.answer-date').pickadate({
    format: 'mm/d/yyyy',
    selectYears: true,
    selectMonths: true
  });

  // Time Picker for Onboarding Questions
  $('.answer-time').pickatime();

  // Date Time Picker for Onboarding Questions
  var datePicker = $('.date-answer-hidden-field').pickadate({
    format: 'mm/d/yyyy',
    selectYears: true,
    selectMonths: true,
    container: '.date-time-picker-output',
    onSet: function (item) {
      if ('select' in item) setTimeout(timePicker.open, 0)
    }
  }).pickadate('picker')

  var timePicker = $('.date-answer-hidden-field').pickatime({
    container: '.date-time-picker-output',
    onRender: function () {
      $('<button class="btn btn-primary">back to date</button>').on('click', function () {
        timePicker.close()
        datePicker.open()
      }).prependTo(this.$root.find('.picker__box'))
    },
    onSet: function (item) {
      if ('select' in item) setTimeout(function () {
        $datetime.off('focus').val(datePicker.get() + ' @ ' + timePicker.get()).focus().on('focus', datePicker.open)
      }, 0)
    }
  }).pickatime('picker')

  var $datetime = $('.answer-date-time').on('focus', datePicker.open).on('click', function (event) {
    event.stopPropagation();
    datePicker.open()
  });
});
