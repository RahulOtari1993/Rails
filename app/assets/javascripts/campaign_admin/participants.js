$(document).on('turbolinks:load', function () {

  // Format Date
  function formatDate(date) {
    let dateObj = new Date(date);
    return ("0" + (dateObj.getMonth() + 1)).slice(-2) + '/' +
        ("0" + (dateObj.getDate())).slice(-2) +
        '/' + dateObj.getFullYear()
  }

  // Participant Server Side Listing
  $('#participant-list-table').DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      'url': `/admin/campaigns/${$('#participant-list-table').attr('campaign_id')}/users/fetch_participants`,
      'dataSrc': 'participants',
      dataFilter: function (data) {
        var json = jQuery.parseJSON(data);
        return JSON.stringify(json);
      },
    },
    columns: [
      {
        title: 'Image', data: null, searchable: false, sortable: false,
        render: function (data, type, row) {
          return '<img src="' + data['avatar']['url'] + '" style="margin-left:25px;" class="table_image_thumb_size" />'
        },
        createdCell: function (td, cellData, rowData, row, col) {
          $(td).css('position', 'relative');
        }
      },
      {
        class: 'product-name',
        title: 'Name', data: null,
        searchable: true,
        render: function (data, type, row) {
          return '<span class="challenge-name" data-challenge-id="' + data.id + '" data-campaign-id="' + data.campaign_id + '">' +
              data.name + '</span>'
        }
      },
      {
        class: 'product-name',
        title: 'Email',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return data.email
        }
      },
      {
        class: 'product-name',
        title: 'Points',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return data.unused_points
        }
      },
      {
        title: 'Eng. Score', data: null, searchable: false,
        render: function (data, type, row) {
          return '0'
        }
      },
      {
        title: 'Infl. Score', data: null, searchable: false,
        render: function (data, type, row) {
          return '0'
        }
      },
      {
        title: 'Joined On', data: null, searchable: false,
        render: function (data, type, row) {
          return formatDate(data.created_at)
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
        text: "<i class='feather icon-download'></i> Export CSV",
        action: function () {
          window.location.href = "/admin/campaigns/" + $('#challenge-list-table').attr('campaign_id') + "/challenges/new"
        },
        className: 'btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light'
      }
    ],
    initComplete: function (settings, json) {
      $('.dt-buttons .btn').removeClass('btn-secondary');
    }
  });

  // Generates Participant Filter Query String
  function generateParticipantFilterParams() {
    var filters = {
      gender: [],
      tags: []
    }

    $("input[name='filters[gender][]']:checked").each(function () {
      filters['gender'].push($(this).data('val'));
    });

    $('.challenge-tags-filter-chip').each(function () {
      filters['tags'].push($(this).data('tag-val'));
    });

    return filters;
  }

  // Apply Participant Filters
  function applyParticipantFilters(filters) {
    if (filters != '') {
      $('#participant-list-table').DataTable().ajax.url(
          "/admin/campaigns/" + $('#participant-list-table').attr('campaign_id') + "/users/fetch_participants"
          + "?filters=" + JSON.stringify(filters)
      )
          .load() //checked
    } else {
      $('#participant-list-table').DataTable().ajax.reload();
    }
  }

  // Participant sidebar status filters
  $('.participant_sidebar_filter').change(function () {
    applyParticipantFilters(generateParticipantFilterParams());
  });
});
