$(document).ready(function () {

  // hide new configuration button based on table data start
  var tableDataLength = $('#index_table_configurations tbody tr').length
  if (tableDataLength > 0) {
    $('#titlebar_right .action_items').hide()
  } else {
    $('#titlebar_right .action_items').show()
  }
  // hide new configuration button based on table data end


});
