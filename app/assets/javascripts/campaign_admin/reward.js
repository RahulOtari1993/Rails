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

  // Make First Letter of a string in Capitalize format
  function textCapitalize(textString) {
    if (textString) {
      return textString.charAt(0).toUpperCase() + textString.slice(1)
    } else {
      return ''
    }
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
          console.log("------CampaignId-------", $('#reward-list-table').attr('campaign_id'))
          var json = jQuery.parseJSON(data);
          return JSON.stringify(json);
      },
    },
    columns: [
      {
        title: 'Image', data: null,searchable: false, 
        render: function(data, type, row){
          html = ''
          if (data.status == 'active') {
            html = '<i class="data_table_status_icon fa fa-circle fa_active fa_circle_sm" aria-hidden="true"></i>';
          } else if (data.status == 'scheduled') {
            html = '<i class="data_table_status_icon fa fa-circle-o fa_scheduled fa_circle_sm" aria-hidden="true"></i>'
          } else {
            html = '<i class="data_table_status_icon fa fa-circle fa_ended fa_circle_sm" aria-hidden="true"></i>'
          }
          html += '<img src="' + data.image['thumb']['url'] + '" style="margin-left:20px;" class="reward_listing_table_image" />'
          return html
        },
        createdCell: function (td, cellData, rowData, row, col) {
          $(td).css('position', 'relative');
        }
      },
      {
        title: 'Name',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return textCapitalize(data.name)
        }
      },
      {
        title: 'Fulfillment',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return textCapitalize(data.selection)
        }
      },
      {
        title: 'Winners',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return textCapitalize(data.selection)
        }
      },
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

  //quill editor
  // Fonts Config for Quill Editor
  var Font = Quill.import('formats/font');
  Font.whitelist = ['sofia', 'slabo', 'roboto', 'inconsolata', 'ubuntu'];
  Quill.register(Font, true);

  // Quill Editor Toolbar Config
  var toolbar = {
    modules: {
      'formula': true,
      'syntax': true,
      'toolbar': [
        [{'font': []}, {'size': []}],
        ['bold', 'italic', 'underline', 'strike'],
        [{'color': []}, {'background': []}],
        [{'script': 'super'}, {'script': 'sub'}],
        [{'header': '1'}, {'header': '2'}, 'blockquote', 'code-block'],
        [{'list': 'ordered'}, {'list': 'bullet'}, {'indent': '-1'}, {'indent': '+1'}],
        ['direction', {'align': []}], ['link', 'image', 'video', 'formula'],
        ['clean']
      ]
    },
    theme: 'snow'
  };

  // Quill Editor for reward description details
  new Quill('.reward-description-editor', toolbar);
  // Quill Editor for reward redemption details
  new Quill('.reward-redemption-editor', toolbar);

  // Add Form Details of Quill Editor to Campaign Form Fields
  $('.edit-reward-form').on('submit', function () {
    $('.description-txt-area').val($('.reward-description-editor .ql-editor').html());
    $('.redemption-txt-area').val($('.reward-redemption-editor .ql-editor').html());
  });

  // Replace ID of Newly Added Fields of User Segment
  function replaceRuleFieldIds(stringDetails, phaseCounter) {
    stringDetails = stringDetails.replace(/\___ID___/g, phaseCounter);
    stringDetails = stringDetails.replace(/___NUM___/g, phaseCounter);
    return stringDetails;
  }

  // Replace ID of Newly Added Fields of User Segment
  // function replaceRewardFieldIds(stringDetails, phaseCounter) {
  //   stringDetails = stringDetails.replace(/\___ID___/g, phaseCounter);
  //   stringDetails = stringDetails.replace(/___NUM___/g, phaseCounter);
  //   return stringDetails;
  // }

  // Adds Validation for New Added Reward Rule Fields
  function addRewardRuleValidations(phaseCounter) {
    // Reward rule Conditions Drop Down Require Validation
    $('#rule-segment-conditions-dd-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a condition"
        }
      })
    });

    // Reward rule type number of logins  
    $('#rule-segment-value-number-of-logins-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 10000,
        digits: true,
        messages: {
          required: "Please enter logins count",
          min: "Minimum count should be 1",
          max: "Maximum count can be 10000",
          digits: "Please enter only digits"
        }
      })
    });

    // Reward rule type Points Validation
    $('#rule-segment-value-points-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 10000,
        digits: true,
        messages: {
          required: "Please enter points",
          min: "Minimum points should be 1",
          max: "Maximum points can be 10000",
          digits: "Please enter only digits"
        }
      })
    });

    // Reward rule type challenge conditions Validation
    $('#rule-segment-value-challenges-completed-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please enter value"
        }
      })
    });

   

    // Reward rule type recruitsValidation
    $('#rule-segment-value-recruits-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please enter value"
        }
      })
    });
  }

  // Adds Validation for New Added Reward filter Fields
   function addRewardValidations(phaseCounter) {
    // Challenge User Segment Conditions Drop Down Require Validation
    $('#reward-segment-conditions-dd-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a condition"
        }
      })
    });

    // Challenge User Segment Age Validation
    $('#reward-segment-value-age-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 100,
        digits: true,
        messages: {
          required: "Please enter age",
          min: "Minimum age should be 1",
          max: "Maximum age can be 100",
          digits: "Please enter only digits"
        }
      })
    });

    // Challenge User Segment Points Validation
    $('#reward-segment-value-points-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 10000,
        digits: true,
        messages: {
          required: "Please enter points",
          min: "Minimum points should be 1",
          max: "Maximum points can be 10000",
          digits: "Please enter only digits"
        }
      })
    });

    // Challenge User Segment Tags Validation
    $('#reward-segment-value-tags-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please enter tag"
        }
      })
    });

    // Challenge User Segment Rewards Validation
    $('#reward-segment-value-rewards-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a reward"
        }
      })
    });

    // Challenge User Segment Platform Validation
    $('#reward-segment-conditions-platforms-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a platform"
        }
      })
    });

    // Challenge User Segment Gender Validation
    $('#reward-segment-value-gender-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select gender"
        }
      })
    });

    // Challenge User Segment Challenge Validation
    $('#reward-segment-value-challenge-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a challenge"
        }
      })
    });
  }

  // Replace ID of Newly Added Fields of User Segment
  function addRewardSelect2(phaseCounter) {
    // Select2 for Reward Dropdown in User Segment Conditions
    $('#reward-segment-value-rewards-' + phaseCounter).select2({
      dropdownAutoWidth: true,
      width: '100%'
    }).next().hide();

    // Select2 for Challenge Dropdown in User Segment Conditions
    $('#reward-segment-value-challenge-' + phaseCounter).select2({
      dropdownAutoWidth: true,
      width: '100%'
    }).next().hide();
  }

  // Add reward rule
  $('.add-reward-rule').on('click', function (e) {
    let rewardRuleSegmentsTemplate = $('#reward-rule-segments-template').html();
    let phaseCounter = Math.floor(Math.random() * 90000) + 10000;

    segmentHtml = replaceRuleFieldIds(rewardRuleSegmentsTemplate, phaseCounter);
    $('.reward-rule-segments-container').append(segmentHtml);

    // Add Validation for Newly Added Elements
    addRewardRuleValidations(phaseCounter);

    // // Add Select2 Drop Down
    // addSelect2(phaseCounter);
  });

  // Add reward rule
  $('.add-reward-segment').on('click', function (e) {
    let rewardSegmentsTemplate = $('#reward-segments-template').html();
    let phaseCounter = Math.floor(Math.random() * 90000) + 10000;
    segmentHtml = replaceRuleFieldIds(rewardSegmentsTemplate, phaseCounter);
    $('.reward-segments-container').append(segmentHtml);

    // Add Validation for Newly Added Elements
    addRewardValidations(phaseCounter);

    // Add Select2 Drop Down
    addRewardSelect2(phaseCounter);
  });


  // Remove rule of Reward Module
  $('body').on('click', '.remove-rule-segment', function (e) {
    $(this).parent().parent().remove();
  });

  // Remove reward segment of Reward Module
  $('body').on('click', '.remove-reward-segment', function (e) {
    $(this).parent().parent().remove();
  });

  // Reward Rule type Change Event
  $('body').on('change', '.rule-event-dd', function (e) {
    var tableRow = $(this).parent().parent();

    // Remove Error Classes of JS Validation & Remove Error Messages
    tableRow.find('span.error').remove();

    // Hide & Disable All the Segmet Condition and Value Fields & Remove Error Class
    tableRow.find('.rule-segment-conditions-container .rule-segment-conditions-dd').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.rule-segment-values-container select').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.rule-segment-values-container input').prop('disabled', true).hide().removeClass('error');

    // Hide Select2 Dropdowns
    // tableRow.find('.segment-values-container select').next(".select2-container").hide();

    // Display Segment Condition Drop Downs
    tableRow.find('.rule-segment-conditions-' + $(this).val()).show().removeAttr('disabled');

    // Display Segment Values Inputs / Drop Downs
    tableRow.find('.rule-segment-value-' + $(this).val()).show().removeAttr('disabled');
    tableRow.find('.rule-segment-value-' + $(this).val()).next(".select2-container").show();
  });

  // Reward Event Change Event
  $('body').on('change', '.reward-event-dd', function (e) {
    var tableRow = $(this).parent().parent();

    // Remove Error Classes of JS Validation & Remove Error Messages
    tableRow.find('span.error').remove();

    // Hide & Disable All the Segmet Condition and Value Fields & Remove Error Class
    tableRow.find('.reward-segment-conditions-container .reward-segment-conditions-dd').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.reward-segment-values-container select').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.reward-segment-values-container input').prop('disabled', true).hide().removeClass('error');

    // Hide Select2 Dropdowns
    tableRow.find('.reward-segment-values-container select').next(".select2-container").hide();

    // Display Segment Condition Drop Downs
    tableRow.find('.reward-segment-conditions-' + $(this).val()).show().removeAttr('disabled');

    // Display Segment Values Inputs / Drop Downs
    tableRow.find('.reward-segment-value-' + $(this).val()).show().removeAttr('disabled');
    tableRow.find('.reward-segment-value-' + $(this).val()).next(".select2-container").show();
  });

   // Add Validations on Already Exists Reward Segments
  setTimeout(function () {
    var ids = $('.existing-filter-ids').data('ids');
    if (ids) {
      ids.forEach(function (segmentId) {
        addValidations(segmentId)
      });
    }
  }, 2000);

  // Add Tag Addition UI from Challenge Popup
  $('body').on('click', '#reward_filter_applied', function (e) {
    if ($('#reward_filter_applied').is(":checked")) {
      $('.filters-container').show();
      $('.reward-rule-segments-container input').prop('disabled', false);
      $('.reward-rule-segments-container select').prop('disabled', false);
    } else {
      $('.reward-rule-segments-container input').prop('disabled', true);
      $('.reward-rule-segments-container select').prop('disabled', true);
      $('.filters-container').hide();
    }
  });

  // Reward sidebar status filters
  $('.reward_sidebar_filter').change(function () {
    var status_checked = []
    // var type_checked = []
    // var platform_checked = []
    // var reward_checked = []
    var filter = {}
    $("input[name='filters[status][]']:checked").each(function () {
      status_checked.push($(this).parent().find('.filter_label').html());
    });
    filter["status"] = status_checked
    // $("input[name='filters[challenge_type][]']:checked").each(function () {
    //   type_checked.push($(this).parent().find('.filter_label').html());
    // });
    // filter['challenge_type'] = type_checked
    // $("input[name='filters[platform_type][]']:checked").each(function () {
    //   platform_checked.push($(this).parent().find('.filter_label').html());
    // });
    // filter['platform_type'] = platform_checked
    // $("input[name='filters[reward_type][]']:checked").each(function () {
    //   reward_checked.push($(this).parent().find('.filter_label').html());
    // });
    // filter['reward_type'] = reward_checked
    if (filter != '') {
      $('#reward-list-table').DataTable().ajax.url(
          "/admin/campaigns/" + $('#reward-list-table').attr('campaign_id') + "/rewards/generate_reward_json"
          + "?filters=" + JSON.stringify(filter)
      ).load() //checked
    } else {
      $('#challenge-list-table').DataTable().ajax.reload();
    }
  });

  //Reset filter checkboxes
  $('.reset_reward_filter_checkboxes').on('click', function(e){
    $('input:checkbox').each(function() { this.checked = false; });
    $('#reward-list-table').DataTable().ajax.url(
          "/admin/campaigns/" + $('#reward-list-table').attr('campaign_id') + "/rewards/generate_reward_json"
      ).load() 
  })

  // Reward Tags
  $('.reward-tags').select2({
    placeholder: "Select Tags",
    tags: true,
    dropdownAutoWidth: true,
  });

  // Replace Chip Value & Chip Class of Newly Added Tags of Challenge Filter
  function replaceTagFields(stringDetails, tagHtml, tagVal) {
    var chipClasses = ['chip-success', 'chip-warning', 'chip-danger', 'chip-primary']
    var chipClass = chipClasses[Math.floor(Math.random() * chipClasses.length)];

    stringDetails = stringDetails.replace(/---TAG-HTML---/g, tagHtml);
    stringDetails = stringDetails.replace(/---TAG-VAL---/g, tagVal);
    stringDetails = stringDetails.replace(/---TAG-UI---/g, chipClass);
    return stringDetails;
  }

  // Tags Selection in Rewards Filter With Auto Suggestion
  $('.reward-tags-filter').select2({
    placeholder: "Select Tag",
    tags: true,
    dropdownAutoWidth: true,
  }).on("select2:select", function (e) {
    let tagTemplate = $('#reward-filter-tag-template').html();
    tagHtml = replaceTagFields(tagTemplate, $('.reward-tags-filter :selected').text(), $('.reward-tags-filter :selected').val());
    $('.filter-tag-selection').append(tagHtml);

    // Reset Tags Selector
    $('.reward-tags-filter').val(null).trigger('change');

    // var filters = generateFilterParams();
    // console.log("filter", filters);
    //
    // applyFilters(filters);
  });

  // Remove Tag From Rewards Filters
  $('body').on('click', '.filter-tag-selection .chip-closeable', function (e) {
    $(this).parent().parent().remove();
  });
})


