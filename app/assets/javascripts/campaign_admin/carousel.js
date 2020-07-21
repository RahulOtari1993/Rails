$(document).on('turbolinks:load', function () {
  // Make First Letter of a string in Capitalize format
  function textCapitalize(textString) {
    if (textString) {
      return textString.charAt(0).toUpperCase() + textString.slice(1)
    } else {
      return ''
    }
  }

  // List Rewards
  $('#carousel-list-table').DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      "url": "/admin/campaigns/" + $('#carousel-list-table').attr('campaign_id') + "/template/carousel/fetch_carousels",
      "dataSrc": "carousels",
      dataFilter: function (data, callback, settings) {
        var json = jQuery.parseJSON(data);
        return JSON.stringify(json);
      },
    },
    columns: [
      {
        title: 'Image', data: null, searchable: false,
        render: function (data, type, row) {
          html = ''
          html += '<img src="' + data.image['thumb']['url'] + '" style="margin-left:25px;" class="table_image_thumb_size" />'
          return html
        }
      },
      {
        title: 'Title',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return textCapitalize(data.name)
        }
      },
      {
        title: 'Description',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return textCapitalize(data.selection)
        }
      }
    ],
    dom: '<"top"<"actions action-btns"B><"action-filters"lf>><"clear">rt<"bottom"<"actions">p>',
    oLanguage: {
      sLengthMenu: "_MENU_",
      sSearch: ""
    },
    aLengthMenu: [[5, 10, 15, 20], [5, 10, 15, 20]],
    order: [[1, "asc"]],
    bInfo: false,
    pageLength: 10,
    aoColumnDefs: [
      {'bSortable': false, 'aTargets': [0]}
    ],
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add Carousel",
        action: function () {
          window.location.href = "/admin/campaigns/" + $('#reward-list-table').attr('campaign_id') + "//template/carousel/new"
        },
        className: "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light"
      }
    ],
    initComplete: function (settings, json) {
      $('.dt-buttons .btn').removeClass('btn-secondary')
    }
  })

  //front-end validations
  $('.reward-form').validate({
    errorElement: 'span',
    ignore: function (index, el) {
      var $el = $(el);

      if ($el.hasClass('always-validate')) {
        return false;
      }

      // Default behavior
      return $el.is(':hidden') || $el.hasClass('ignore');
    },
    rules: {
      'reward[name]': {
        required: true
      },
      'reward[description]': {
        required: true,
        maxlength: 300
      },
      'reward[image]': {
        required: true,
        extension: "jpg|jpeg|png|gif"
      },
      'reward[points]': {
        digits: true
      },
      'reward[limit]': {
        required: true,
        digits: true
      },
      'reward[start]': {
        required: true
      },
      'reward[finish]': {
        required: true
      },
      'reward[msrp_value]': {
        number: true
      },
      'reward[selection]': {
        required: true
      }
    },
    messages: {
      'reward[name]': {
        required: 'Please enter reward name'
      },
      'reward[description]': {
        required: 'Please enter reward description',
        maxlength: 'Maximum 300 characters allowed'
      },
      'reward[image]': {
        required: 'Please select reward photo',
        extension: 'Please select reward photo with valid extension'
      },
      'reward[points]': {
        digits: 'Please enter only digits'
      },
      'reward[limit]': {
        required: 'Please enter reward available',
        digits: 'Please enter only digits'
      },
      'reward[start]': {
        required: 'Please enter start date'
      },
      'reward[finish]': {
        required: 'Please enter end time'
      },
      'reward[msrp_value]': {
        number: 'Please enter numeric value only'
      },
      'reward[selection]': {
        required: 'Please select reward selection type'
      }
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
})
