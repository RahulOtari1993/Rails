$(document).ready(function() {
  // Invite Organization Admin Form Validation
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

  // Add Campaign Form Validation
  $('.add-campaign-form').validate({
    rules: {
      'campaign[name]': {
        required: true
      },
      'campaign[domain]': {
        required: true
      }
    },
    messages: {
      'campaign[name]': {
        required: 'Please enter campaign name'
      },
      'campaign[domain]': {
        required: 'Please enter campaign domain'
      }
    }
  });
});
