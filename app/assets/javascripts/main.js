$(document).ready(function() {
  $('.login_form').validate({
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

  $('.reset_password_form').validate({
    rules: {
      'user[password]': {
        required: true,
        minlength: 8
      },
      'user[password_confirmation]': {
        required: true,
        minlength: 8,
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


