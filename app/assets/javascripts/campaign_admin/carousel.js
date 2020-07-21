$(document).on('turbolinks:load', function () {
  // Make First Letter of a string in Capitalize format
  function textCapitalize(textString) {
    if (textString) {
      return textString.charAt(0).toUpperCase() + textString.slice(1)
    } else {
      return ''
    }
  }

  // List Carousels
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
          var cTitle = data.description
          if (cTitle.length > 30) {
            cTitle = $.trim(cTitle).substring(0, 30).trim(cTitle) + "...";
          }

          return textCapitalize(cTitle)
        }
      },
      {
        title: 'Description',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          var cDescription = data.description
          if (cDescription.length > 90) {
            cDescription = $.trim(cDescription).substring(0, 90).trim(cDescription) + "...";
          }

          return textCapitalize(cDescription)
        }
      },
      {
        title: 'Actions', data: null, searchable: false, orderable: false, width: '20%',
        render: function (data, type, row) {
          // Action items
          return "<a href = '/admin/campaigns/" + data.campaign_id + "/template/carousel/" + data.id + "/edit'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Edit Carousel'" +
              "class='btn btn-icon btn-success mr-1 waves-effect waves-light'><i class='feather icon-edit'></i></a>"
              + "<button class='btn btn-icon btn-warning mr-1 waves-effect waves-light delete-carousel-btn' carousel_id ='" + data.id + "'campaign_id='" + data.campaign_id + "'"
              + "data-toggle='tooltip' data-placement='top' data-original-title='Delete Carousel'>" +
              "<i class='feather icon-trash'></i></button>"
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
          window.location.href = "/admin/campaigns/" + $('#carousel-list-table').attr('campaign_id') + "/template/carousel/new"
        },
        className: "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light"
      }
    ],
    initComplete: function (settings, json) {
      $('.dt-buttons .btn').removeClass('btn-secondary')
    }
  })

  // Front-end Form Validations
  $('.carousel-form').validate({
    errorElement: 'span',
    ignore: function (index, el) {
      // Default behavior
      var $el = $(el);
      return $el.is(':hidden') || $el.hasClass('ignore');
    },
    rules: {
      'carousel[title]': {
        required: true
      },
      'carousel[description]': {
        required: true,
        maxlength: 200
      },
      'carousel[image]': {
        required: true,
        extension: "jpg|jpeg|png|gif"
      },
      'carousel[link]': {
        url: true
      }
    },
    messages: {
      'carousel[title]': {
        required: 'Please enter carousel title'
      },
      'carousel[description]': {
        required: 'Please enter carousel description',
        maxlength: 'Maximum 200 characters allowed'
      },
      'carousel[image]': {
        required: 'Please select carousel photo',
        extension: 'Please select carousel photo with valid extension'
      },
      'carousel[link]': {
        url: 'Please enter valid link'
      }
    }
  });

  // Delete a Carousel
  $('.carousel-list-container').on('click', '.delete-carousel-btn', function () {
    var carousel = $(this).attr('carousel_id');

    $.ajax({
      type: 'DELETE',
      data: {authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + $('#carousel-list-table').attr('campaign_id') + "/template/carousel/" + carousel
    });
  });
})
