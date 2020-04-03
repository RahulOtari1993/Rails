$(document).on('turbolinks:load', function() {
  // Auto Hide Flash Message after 3 Seconds
  setTimeout(function(){
    $('.alert').fadeOut();
  }, 3000);

  // When User Close a Flash Message
  $('body').delegate('.flash-close', 'click', function (e) {
    $('.alert').fadeOut();
  });

  // Domain Name Validation
  $.validator.addMethod('domainRegex', function (value) {
    return /^[\w\-]+$/.test(value);
  }, 'Domain is not allowed. Please choose another subdomain.');
});
