$(document).on('turbolinks:load', function() {
  // Color Picker Integration
  $('.colour-picker-txt').minicolors({theme: 'bootstrap'})

  // Open Template Editor on Page Load
  $('.action-edit').trigger('click');
});
