$(document).on('turbolinks:load', function() {

 
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
  var dataThumbView = $("#reward_listing").DataTable({
    "processing": true,
    "serverSide": true,
    responsive: false,
    ajax: {
        "url": "/admin/campaigns/" +  $('#reward_listing').attr('campaign_id') + "/rewards/generate_reward_json",
        "dataSrc": "rewards",
    },
    columns: [
      {title: 'Image', data: null,searchable: false, 
        render: function(data, type, row){
          return '<img src="' +data.image['thumb']['url']+ '" />';
        }
      },
      {title: 'Name', data:'name', searchable: true},
      {title: 'Fulfillment', data: 'selection',searchable: false},
      {title: 'Winners', data: 'selection',searchable: false},
      {title: 'Start Date', data: null,searchable: false,
        render: function(data, type, row){
         return formatDate(data.start)       
        }
      },
      {title: 'End date', data: null,searchable: false,
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
    aLengthMenu: [[4, 10, 15, 20], [4, 10, 15, 20]],
    select: {
      style: "multi"
    },
    order: [[2, "desc"]],
    bInfo: false,
    pageLength: 10,
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
  dataThumbView.on('draw.dt', function(){
    setTimeout(function(){
      if (navigator.userAgent.indexOf("Mac OS X") != -1) {
        $(".dt-checkboxes-cell input, .dt-checkboxes").addClass("mac-checkbox")
      }
    }, 50);
  });
  // dropzone init
  Dropzone.options.dataListUpload = {
    complete: function(files) {
      var _this = this
      // checks files in class dropzone and remove that files
      $(".hide-data-sidebar, .cancel-data-btn, .actions .dt-buttons").on(
        "click",
        function() {
          $(".dropzone")[0].dropzone.files.forEach(function(file) {
            file.previewElement.remove()
          })
          $(".dropzone").removeClass("dz-started")
        }
      )
    }
  }
  Dropzone.options.dataListUpload.complete()

  // mac chrome checkbox fix
  if (navigator.userAgent.indexOf("Mac OS X") != -1) {
    $(".dt-checkboxes-cell input, .dt-checkboxes").addClass("mac-checkbox")
  }

  //Datepicker
  // $('.reward-format-picker').pickadate({
  //       format: 'mmmm, d, yyyy'
  // });
});

// UMD
