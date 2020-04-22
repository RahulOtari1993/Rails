$(document).ready(function () {
  //reward selection dropdown onchange 
  $('#reward_selection').on('change', function () {
    if ($(this).val() == 'redeem' || $(this).val() == 'instant' || $(this).val() == 'selection') {
      $('.threshold').show();
    } else if ($(this).val() == 'manual' || $(this).val() == 'threshold') {
      $('.threshold').hide();
    } else if ($(this).val() == 'sweepstake') {
      $('.threshold').hide();
      $('.sweepstake').show();
    } else {
    }
  })

  //hide row in reward new and delete/hide row/reward_filter in edit page
  $('body').on('click', '.remove-reward-segment', function(e){
    e.preventDefault();  
    var element = null
    element= $(this)
    if($(this).attr('reward_filter_id') != undefined){ 
      $.ajax({
        type: 'POST',
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},
        url: "/admin/delete_reward_filter/" + $(this).attr('reward_filter_id'),
        success: function(data, res){
          element.closest('tr').remove();
        }
      });
    }else{
      element.parent().parent().remove();
    }
  })

  //Download CSV
  $('#reward_listing').on('click', '.download-csv-btn', function(){
    var reward_id = $(this).attr('reward_id')
    var campaign_id = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaign_id + "/rewards/" + reward_id  + "/ajax_user"
    });
  });

  $('#reward_listing').on('click', '.coupon-btn', function(){
    var reward_id = $(this).attr('reward_id')
    var campaign_id = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaign_id + "/rewards/" + reward_id  + "/ajax_coupon_form"
    });
  });

  //datetime format 
  function formatDate(date){
    let current_datetime = new Date(date);
    let formatted_date = current_datetime.getFullYear() + "-" + (current_datetime.getMonth() + 1) + "-" + current_datetime.getDate()
    return formatted_date
  }

  //thumbview list
  $("#reward_listing").DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      "url": "/admin/campaigns/" +  $('#reward_listing').attr('campaign_id') + "/rewards/generate_reward_json",
      "dataSrc": "rewards",
      dataFilter: function(data, callback, settings){
          var json = jQuery.parseJSON(data);
          return JSON.stringify(json);
      },
    },
    columns: [
      {title: 'Image', data: null,searchable: false, 
        render: function(data, type, row){
          return '<img src="' + data.image['thumb']['url'] + '" />';
        }
      },
      {title: 'Name', data:'name', searchable: true},
      {title: 'Fulfillment', data: 'selection',searchable: false },
      {title: 'Winners', data: 'selection', searchable: false},
      {title: 'Start Date', data: null, searchable: false,
        render: function(data, type, row){
         return formatDate(data.start)       
        }
      },
      {title: 'End date', data: null, searchable: false,
        render: function(data, type, row){
         return formatDate(data.finish)       
        }
      },
      {title: 'Actions', data: null, searchable: false, orderable: false,
        render: function ( data, type, row ) {
            // Combine the first and last names into a single table field
          return  "<a href = /admin/campaigns/" + data.campaign_id + "/rewards/" + data.id + "/edit>" + "<span class='action-edit'><i class='feather icon-edit'></i></span></a>"
                  +"<button class='btn btn-xs btn-action download-csv-btn' reward_id ='" + data.id +"'campaign_id='" + data.campaign_id + "'>" + "<i class='feather icon-download'></i></span></button>" + "<button class='btn btn-xs btn-action btn-primary coupon-btn' reward_id ='" + data.id + "'campaign_id='" + data.campaign_id + "'>Coupons</button>"
         }
      },
    ],
    columnDefs: [
      {
        orderable: true,
        targets: 0
      }
    ],
    dom:
      '<"top"<B><"action-filters"lf>><"clear">rt<"bottom"p>',
    oLanguage: {
      sLengthMenu: "_MENU_",
      sSearch: ""
    },
    aLengthMenu: [[10, 15, 20], [10, 15, 20]],
    order: [[1, "asc"]],
    bInfo: false,
    pageLength: 10,
    select: {
      style: "multi"
    },
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add Reward",
        action: function() {
          window.location.href = "/admin/campaigns/" + $('#reward_listing').attr('campaign_id') + "/rewards/new"
        },
        className: "btn-outline-primary"
      }
    ],
    initComplete: function(settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary")
    }
  })

  //Reward datepicker
  // Date Picker (Disabled all the Past Dates)
  $('.pick-reward-date').pickadate({
    format: 'mm/d/yyyy',
    selectYears: true,
    selectMonths: true,
    min: true
  });

  // Time Picker
  $('.pick-reward-time').pickatime();
  
  //Submit form onclick skipping all input fields which are disabled
  // $('.reward_form').on('click', function () {
  //   // $('.segment_table').find('.filter_hidden').attr("disabled", true);
  //   // var selects = $('.segment_table').find('select');
  //   // var inputs = $('.segment_table').find('input');
  //   // var rows = $('.segment_table').find('tr')

  //   // for (var i = 0; i < selects.length; i++) {
  //   //   if (selects[i].style.display == 'none') {
  //   //     selects[i].disabled = true;
  //   //   }
  //   // }

  //   // for (var i = 0; i < inputs.length; i++) {
  //   //   if (inputs[i].style.display == 'none') {
  //   //     inputs[i].disabled = true;
  //   //   }
  //   // }
  //   // for (var i = 0; i < rows.length; i++) {
  //   //   if (rows[i].style.display == 'none') {
  //   //     $formInputs = $(this).find('input')
  //   //     $formSelects = $(this).find('select')

  //   //     $formInputs.prop("disabled", true);
  //   //     $formSelects.prop("disabled", true)
  //   //   }
  //   // }
  //   $('form').submit();
  // })
})


