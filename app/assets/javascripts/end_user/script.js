$(document).on('turbolinks:load', function() {
  // Close Popup Modal
  $('.modal-close-btn').click(function() {
    $(this).parent().parent().modal('hide');
  });
});
