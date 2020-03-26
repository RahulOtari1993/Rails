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
});


