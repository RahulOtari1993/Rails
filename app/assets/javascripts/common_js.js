$(document).ready(function(){
  // Auto Hide Flash Message after 3 Seconds
  setTimeout(function(){
    $('.alert').fadeOut();
  }, 3000);

  // When User Close a Flash Message
  $('body').delegate('.flash-close', 'click', function (e) {
    $('.alert').fadeOut();
  });
});
