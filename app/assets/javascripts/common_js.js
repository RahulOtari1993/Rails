$(document).on('turbolinks:load', function() {
  // Auto Hide Flash Message after 7 Seconds
  $('.alert').delay(7000).slideUp(300);

  // When User Close a Flash Message
  $('body').delegate('.flash-close', 'click', function (e) {
    $('.alert').fadeOut();
  });

  // Domain Name Validation
  $.validator.addMethod('subDomainRegex', function (value) {
    return /^[\w\-]+$/.test(value);
  }, 'Domain is not allowed. Please choose another subdomain.');

  // Domain Name Validation
  $.validator.addMethod('urlWithOutProtocolRegex', function (value) {
    return /^(?:(http|https)?:\/\/)?(?:[\w-]+\.)+([a-z]|[A-Z]|[0-9]){2,6}$/.test(value);
  }, 'Domain is not allowed. Please choose another subdomain.');

  $.validator.addClassRules({
    'sub-domain-field': {
      subDomainRegex: true
    },
    'own-domain-field': {
      urlWithOutProtocolRegex: true
    }
  });

  // Change Domain Field
  $('.campaign-common-form').on('change', '.domain_type_id', function () {
    if ($(this).val() == 'include_in_domain') {
      $('.include-in-domain-selection').show();
      $('.include-in-domain-selection input').prop("disabled", false);
      $('.own-domain-selection').hide();
      $('.own-domain-selection input').prop("disabled", true);
    } else {
      $('.own-domain-selection').show();
      $('.own-domain-selection input').prop("disabled", false);
      $('.include-in-domain-selection').hide();
      $('.include-in-domain-selection input').prop("disabled", true);
    }
  });
});
