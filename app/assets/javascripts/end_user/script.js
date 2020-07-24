$(document).on('turbolinks:load', function () {
  // Fadeout Alert Message
  $('.alert').fadeOut(3000);

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
      buttonsStyling: false
    }).then(function() {
      $('.challenge-modal').modal('hide');
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
          swalNotify('Challenge Submission', data.message);
          _this.hide();
        } else {
          swalNotify('Challenge Submission', data.message);
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

  if ($('#onboarding_questions_modal').length > 0 ) {
    initializeDateTimePicker();
  }

  $('.onboarding-questions-form').validate({
    errorElement: 'div',
    errorPlacement: function (error, element) {
      var placement = $(element).data('error');
      if (placement) {
        $('.' + placement).html(error)
      } else {
        error.insertAfter(element);
      }
    }
  })

  customQuestionValidation();

  $('.participant-profile-form').validate({
    errorElement: 'div',
    errorPlacement: function (error, element) {
      var placement = $(element).data('error');
      if (placement) {
        $('.' + placement).html(error)
      } else {
        error.insertAfter(element);
      }
    }
  })

  // Open Reward Claim Modal Popup
  $('body').on('click', '.reward-claim-modal-btn', function (e) {
    var rewardId = $(this).data('reward-id');
    var challengeId = $(this).data('challenge-id');

    if (challengeId == '' || challengeId == undefined) {
      // open rewards modal popup
      $.ajax({
        type: 'GET',
        url: `/participants/rewards/${rewardId}/details`
      });
    } else {
      // open challenge submission modal popup
      $.ajax({
        type: 'GET',
        url: `/participants/challenges/${challengeId}/details`,
        data: {reward_id: rewardId}
      });
    }
  });

  // claim Reward submission - start
  $('.cash_in_modal').on('click', 'reward-claim-btn', function (e) {
    var rewardId = $(this).data('reward-id');
    var _this = $(this);

    $.ajax({
      url: `/participants/rewards/${rewardId}/claim`,
      type: 'POST',
      dataType: 'JSON',
      success: function (data) {
        if (data.success) {
          $('.reward-claim-container').show();     // Display Reward Completion Message
          _this.hide();
        } else {
          swalNotify('Reward Claimed', data.message);
        }
      }
    });
  });
  // claim Reward submission - end


  // Edit Participant details Popup
  $('body').on('click', '.edit-participant-profile-btn', function (e) {
    $.ajax({
      type: 'GET',
      url: '/participants/accounts/details_form'
    });
  });

  $(document).on( "change", "#participant_avatar", function() {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#participant_profile_avatar').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  // Disconnect Existing Connected Social Media Account
  $('body').on('click', '.disconnect-btn', function (e) {
    let type = $(this).data('connection-type');

    $.ajax({
      url: '/participants/accounts/disconnect',
      type: 'PUT',
      // dataType: 'script',
      data: {
        connection_type: type,
        authenticity_token: $('[name="csrf-token"]')[0].content,
      }
    });
  });
});

// Function to Add Custom Validation of Questions
function customQuestionValidation() {
  $.validator.addMethod('stringRequired', $.validator.methods.required, 'This field is required.');

  $.validator.addMethod('decimalRequired', $.validator.methods.number, 'This field accepts only numbers & decimals.');

  $.validator.addMethod('numberRequired', $.validator.methods.digits, 'This field accepts only numbers.');

  $.validator.addClassRules({
    'answer-string-required': {
      stringRequired: true
    },
    'answer-text-area-required': {
      stringRequired: true
    },
    'answer-date-required': {
      stringRequired: true
    },
    'answer-time-required': {
      stringRequired: true
    },
    'answer-date-time-required': {
      stringRequired: true
    },
    'answer-number-required': {
      stringRequired: true,
      numberRequired: true
    },
    'answer-decimal-required': {
      stringRequired: true,
      decimalRequired: true
    },
    'answer-dropdown-required': {
      stringRequired: true
    }
  })

  if ($('.answer-radio-button-required').length > 0) {
    $('.answer-radio-button-required').each(function () {
      $(this).rules('add', {
        required: true
      });
    });
  }

  if ($('.answer-check-box-required').length > 0) {
    $('.answer-check-box-required').each(function () {
      $(this).rules('add', {
        required: true
      });
    });
  }
}

function initializeDateTimePicker() {
  let datePickerIcons = {
    time: 'fa fa-clock-o',
    date: 'fa fa-calendar',
    up: 'fa fa-chevron-up',
    down: 'fa fa-chevron-down',
    previous: 'fa fa-chevron-left',
    next: 'fa fa-chevron-right',
    today: 'fa fa-check',
    clear: 'fa fa-trash',
    close: 'fa fa-times'
  }

  // Date Picker for Onboarding Questions
  $('.answer-date').datetimepicker({
    format: 'L',
    icons:datePickerIcons
  });

  // Time Picker for Onboarding Questions
  $('.answer-time').datetimepicker({
    format: 'LT',
    icons:datePickerIcons
  });

  // Date Time Picker for Onboarding Questions
  $('.answer-date-time').datetimepicker({
    format: 'MM/DD/YYYY hh:mm A',
    icons:datePickerIcons
  });
}
