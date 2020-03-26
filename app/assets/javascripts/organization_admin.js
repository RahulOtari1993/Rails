$(document).ready(function() {
  $('#new_organizations_user').validate({
    rules: {
      'organizations_user[first_name]': {
        required: true
      },
      'organizations_user[last_name]': {
        required: true
      },
      'organizations_user[email]': {
        required: true,
        email: true
      }
    },
    messages: {
      'organizations_user[first_name]': {
        required: 'Please enter organization admin first name'
      },
      'organizations_user[last_name]': {
        required: 'Please enter organization admin last name'
      },
      'organizations_user[email]': {
        required: 'Please enter organization admin email',
        email: 'Please enter valid organization admin email'
      }
    }
  });
});
