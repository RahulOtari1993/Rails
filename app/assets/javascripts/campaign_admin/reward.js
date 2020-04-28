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

  //show download csv popup
  $('#reward-list-table').on('click', '.download-csv-btn', function(){
    var rewardId = $(this).attr('reward_id')
    var campaignId = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaignId + "/rewards/" + rewardId  + "/download_csv_popup"
    });
  });

  //Coupon popup 
  $('#reward-list-table').on('click', '.coupon-btn', function(){
    var rewardId = $(this).attr('reward_id')
    var campaignId = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaignId + "/rewards/" + rewardId  + "/coupon_form"
    });
  });

  // Format Date
  function formatDate(date) {
    let dateObj = new Date(date);
    return ("0" + (dateObj.getMonth() + 1)).slice(-2) + '/' +
        ("0" + (dateObj.getDate() + 1)).slice(-2) +
        '/' + dateObj.getFullYear()
  }

  //thumbview list
  $("#reward-list-table").DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      "url": "/admin/campaigns/" +  $('#reward-list-table').attr('campaign_id') + "/rewards/generate_reward_json",
      "dataSrc": "rewards",
      dataFilter: function(data, callback, settings){
          var json = jQuery.parseJSON(data);
          return JSON.stringify(json);
      },
    },
    columns: [
      {title: 'Image', data: null,searchable: false, 
        render: function(data, type, row){
          return '<img src="' + data.image['thumb']['url'] + '" class="reward_listing_table_image"/>';
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
      {title: 'Actions', data: null, searchable: false, orderable: false, width: '30%',
        render: function ( data, type, row ) {
            // Action items
          return  "<a href = '/admin/campaigns/" + data.campaign_id + "/rewards/" + data.id + "/edit'" +
                  "data-toggle='tooltip' data-placement='top' data-original-title='Edit Reward'" + 
                  "class='btn btn-icon btn-success mr-1 waves-effect waves-light'><i class='feather icon-edit'></i></a>"
                  +"<button class='btn btn-icon btn-warning mr-1 waves-effect waves-light download-csv-btn' reward_id ='" + data.id +"'campaign_id='" + data.campaign_id + "'" 
                  + "data-toggle='tooltip' data-placement='top' data-original-title='Download CSV file of reward participants'>" +
                  "<i class='feather icon-download'></i></button>" + 
                  "<span style='display:inline'><button class='btn btn-sm btn-action btn-primary coupon-btn' reward_id ='" + data.id + "'campaign_id='" + data.campaign_id 
                  + "'>Coupons</button></span>"
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
          window.location.href = "/admin/campaigns/" + $('#reward-list-table').attr('campaign_id') + "/rewards/new"
        },
        className: "btn-outline-primary"
      }
    ],
    initComplete: function(settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary")
    }
  })

  // Reward Date Picker (Disabled all the Past Dates)
  $('.pick-reward-date').pickadate({
    format: 'mm/d/yyyy',
    selectYears: true,
    selectMonths: true,
    min: true
  });

  // Reward Time Picker
  $('.pick-reward-time').pickatime();

  //front-end validations
  $('.reward-form').validate({
    errorElement: 'span',
    ignore: function (index, el) {
      var $el = $(el);

      if ($el.hasClass('always-validate')) {
        return false;
      }

      // Default behavior
      return $el.is(':hidden');
    },
    rules: {
      'reward[name]': {
        required: true
      },
      'reward[description]': {
        required: true
      },
      'reward[image]': {
        required: true,
        extension: "jpg|jpeg|png|gif"
      },
      'reward[points]': {
        digits: true
      },
      'reward[limit]': {
        digits: true
      },
      'social_description': {
        socialDesctiption: true
      },
      'reward[start]': {
        required: true
      },
      'reward[finish]': {
        required: true
      }
    },
    messages: {
      'reward[name]': {
        required: 'Please enter reward name'
      },
      'reward[description]': {
        required: 'Please enter reward description'
      },
      'reward[image]': {
        required: 'Please select reward photo',
        extension: 'Please select reward photo with valid extension'
      },
      'reward[points]': {
        required: 'Please enter points',
        digits: 'Please enter only digits'
      },
      'reward[start]': {
        required: 'Please enter start date'
      },
      'reward[finish]': {
        required: 'Please enter end time'
      },
    },
    errorPlacement: function (error, element) {
      var placement = $(element).data('error');
      if (placement) {
        $('.' + placement).append(error)
      } else {
        error.insertAfter(element);
      }
    }
  });

  //Image name display
  $('.reward-custom-file-label').on('change',function(e){
    //get the file name
    var fileName = e.target.files[0].name;
    $('.custom-file-label').html(fileName);
  })


})


