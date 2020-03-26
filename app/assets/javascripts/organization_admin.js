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
        required: 'Please enter user first name'
      },
      'organizations_user[last_name]': {
        required: 'Please enter user last name'
      },
      'organizations_user[email]': {
        required: 'Please enter user email',
        email: 'Please enter valie email'
      }
    }
  });
});
