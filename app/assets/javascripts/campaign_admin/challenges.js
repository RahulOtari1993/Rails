$(document).on('turbolinks:load', function() {
  var form = $(".challenge-wizard");

  $('.challenge-wizard').steps({
    headerTag: "h6",
    bodyTag: "fieldset",
    transitionEffect: "fade",
    titleTemplate: '<span class="step">#index#</span> #title#',
    labels: {
      finish: 'Submit'
    },
    onStepChanging: function (event, currentIndex, newIndex) {
      // Allways allow previous action even if the current form is not valid!
      if (currentIndex > newIndex) {
        return true;
      }

      return form.valid();
    },
    onFinishing: function (event, currentIndex) {
      return form.valid();
    },
    onFinished: function (event, currentIndex) {
      $('.challenge-wizard' ).submit();
    }
  });

  $('.challenge-wizard').validate({
    errorElement: 'span',
    rules: {
      'challenge[mechanism]': {
        required: true
      },
      'challenge[name]': {
        required: true
      },
      'challenge[link]': {
        required: true,
        url: true
      },
      'challenge[description]': {
        required: true
      },
      // 'hk_s3_1': {
      //   required: true,
      //   minlength: 8
      // },
      // 'hk_s4_1': {
      //   required: true
      // },
      // 'hk_s4_2': {
      //   required: true
      // },
      // 'hk_s5_1': {
      //   required: true
      // }
    },
    messages: {
      'challenge[mechanism]': {
        required: 'Please select challenge type'
      },
      'challenge[name]': {
        required: 'Please enter challenge name'
      },
      'challenge[link]': {
        required: 'Please enter link to be shared',
        url: 'Please enter valid link'
      },
      'challenge[description]': {
        required: 'Please enter challenge description'
      },
      // 'hk_s3_1': {
      //   required: 'Please enter new password',
      //   minlength: 'Password is too short (minimum is 8 characters)'
      // },
      // 'hk_s4_1': {
      //   required: 'Please enter first name'
      // },
      // 'hk_s4_2': {
      //   required: 'Please enter last name'
      // },
      // 'hk_s5_1': {
      //   required: 'Please enter email address'
      // }
    }
  });
});
