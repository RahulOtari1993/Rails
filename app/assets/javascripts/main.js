$(document).on('turbolinks:load', function() {
  $('.login_form').validate({
    errorElement: 'span',
    rules: {
      'user[email]': {
        required: true,
        email: true
      },
      'user[password]': {
        required: true
      }
    },
    messages: {
      'user[email]': {
        required: 'Please enter user email',
        email: 'Please enter valid user email'
      },
      'user[password]': {
        required: 'Please enter user password'
      }
    }
  });

  $('.forgot_password_form').validate({
    errorElement: 'span',
    rules: {
      'user[email]': {
        required: true,
        email: true
      }
    },
    messages: {
      'user[email]': {
        required: 'Please enter user email',
        email: 'Please enter valid user email'
      }
    }
  });

  // Password Complexity Validaton Added
  $.validator.addMethod('passwordRegex', function (value) {
    return /((?:(?=.*[a-z])(?=.*[A-Z])(?=.*\W)|(?=.*\d)(?=.*[A-Z])(?=.*\W)|(?=.*\d)(?=.*[a-z])(?=.*\W)|(?=.*\d)(?=.*[a-z])(?=.*[A-Z])).*)/.test(value);
  }, 'Complexity requirement not met. Must contain 3 of the following 4: 1) A lowercase letter, 2) An uppercase letter, 3) A digit, 4) A non-word character or symbol');

  $('.reset_password_form').validate({
    errorElement: 'span',
    rules: {
      'user[password]': {
        required: true,
        minlength: 8,
        passwordRegex: true
      },
      'user[password_confirmation]': {
        required: true,
        minlength: 8,
        passwordRegex: true,
        equalTo: "#user_password"
      }
    },
    messages: {
      'user[password]': {
        required: 'Please enter new password',
        minlength: 'Password is too short (minimum is 8 characters)'
      },
      'user[password_confirmation]': {
        required: 'Please enter new confirm password',
        minlength: 'Password is too short (minimum is 8 characters)',
        equalTo: 'Confirm password do not match'
      }
    }
  });
});
