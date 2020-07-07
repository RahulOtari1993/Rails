$(document).on('turbolinks:load', function() {
  // Invite Participant Form Validation
  ahoy.trackAll();
  $('.participant-sign-up-form').validate({
    errorElement: 'span',
    rules: {
      'participant[first_name]': {
        required: true
      },
      'participant[last_name]': {
        required: true
      },
      'participant[email]': {
        required: true,
        email: true
      },
      'participant[email_confirmation]': {
        required: true,
        email: true,
        equalTo: "#participant_email"
      },
      'participant[password]': {
        required: true,
        minlength: 8,
        passwordRegex: true
      },
      'participant[password_confirmation]': {
        required: true,
        minlength: 8,
        passwordRegex: true,
        equalTo: "#participant_password"
      }
    },
    messages: {
      'participant[first_name]': {
        required: 'Please enter first name'
      },
      'participant[last_name]': {
        required: 'Please enter last name'
      },
      'participant[email]': {
        required: 'Please enter email address',
        email: 'Please enter valid email address'
      },
      'participant[email_confirmation]': {
        required: 'Please enter confirm email address',
        email: 'Please enter valid email address',
        equalTo: 'Confirm email do not match'
      },
      'participant[password]': {
        required: 'Please enter new password',
        minlength: 'Password is too short (minimum is 8 characters)'
      },
      'participant[password_confirmation]': {
        required: 'Please enter new confirm password',
        minlength: 'Password is too short (minimum is 8 characters)',
        equalTo: 'Confirm password do not match'
      }
    }
  });






});
