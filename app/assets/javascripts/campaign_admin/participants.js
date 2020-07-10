$(document).on('turbolinks:load', function () {
  // Format Date
  function formatDate(date) {
    let dateObj = new Date(date);
    return ("0" + (dateObj.getMonth() + 1)).slice(-2) + '/' +
        ("0" + (dateObj.getDate())).slice(-2) +
        '/' + dateObj.getFullYear()
  }

  // Trigger SWAL Notificaton
  function swalNotify(title, message) {
    Swal.fire({
      title: title,
      text: message,
      confirmButtonClass: 'btn btn-primary',
      buttonsStyling: false,
    });
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
          return '<span class="participant-name" data-participant-id="' + data.id + '" data-campaign-id="' + data.campaign_id + '">' +
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
      },
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
        className: 'btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light export-participant-btn'
      }
    ],
    initComplete: function (settings, json) {
      $('.dt-buttons .btn').removeClass('btn-secondary');
    }
  });

  // Open Popup for Participant Details
  $('#participant-list-table').on('click', '.participant-name', function(){
    var participantId = $(this).data('participant-id');
    var campaignId = $(this).data('campaign-id');
    $.ajax({
      type: 'GET',
      url: "/admin/campaigns/" + campaignId + "/users/" + participantId
    });
  });

  // Generates Participant Filter Query String
  function generateParticipantFilterParams() {
    var filters = {
      gender: [],
      tags: [],
      challenges: [],
      rewards: [],
      age: []
    }

    $("input[name='filters[gender][]']:checked").each(function () {
      filters['gender'].push($(this).data('val'));
    });

    $('.participants-filter-tag-selection .participant-tags-filter-chip').each(function () {
      filters['tags'].push($(this).data('tag-val'));
    });

    $('.participants-filter-challenges-selection .participant-tags-filter-chip').each(function () {
      filters['challenges'].push($(this).data('tag-val'));
    });

    $('.participants-filter-rewards-selection .participant-tags-filter-chip').each(function () {
      filters['rewards'].push($(this).data('tag-val'));
    });

    filters['age'] = [parseInt($('.filter-min-age').text()), parseInt($('.filter-max-age').text())]

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
  };

  // Open Popup for Filtered Participants
  $('body').on('click', '.export-participant-btn', function () {
    var campaignId = $('#participant-list-table').attr('campaign_id');
    var filters = generateParticipantFilterParams();
    filters['search_term']= $('#participant-list-table_wrapper .dataTables_filter input').val()

    var url = "/admin/campaigns/" + campaignId + "/users/participants?filters=" + JSON.stringify(filters)
    window.open(url, '_blank');

    // $.ajax({
    //   type: 'POST',
    //   data: {'filters': filters, authenticity_token: $('[name="csrf-token"]')[0].content},
    //   url: "/admin/campaigns/" + campaignId + "/users/participants", // + JSON.stringify(filters)
    // });
  });

  // Replace Chip Value & Chip Class of Newly Added Tags of Participant Filter
  function replaceParticipantTagFields(stringDetails, tagHtml, tagVal) {
    const chipClasses = ['chip-success', 'chip-warning', 'chip-danger', 'chip-primary']
    const chipClass = chipClasses[Math.floor(Math.random() * chipClasses.length)];

    // Truncate Tag
    if (tagHtml.length > 20)
      tagHtml = jQuery.trim(tagHtml).substring(0, 20).trim(tagHtml) + "...";

    stringDetails = stringDetails.replace(/---TAG-HTML---/g, tagHtml);
    stringDetails = stringDetails.replace(/---TAG-VAL---/g, tagVal);
    stringDetails = stringDetails.replace(/---TAG-UI---/g, chipClass);
    return stringDetails;
  }

  // Participant sidebar status filters
  $('.participant_sidebar_filter').change(function () {
    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Tags Selection in Participant Filter With Auto Suggestion
  $('.participants-tags-filter').select2({
    placeholder: "Select Tag",
    tags: true,
    dropdownAutoWidth: true,
    width: '100%'
  }).on("select2:select", function (e) {
    let tagTemplate = $('#participant-filter-tag-template').html();
    let tagHtml = replaceParticipantTagFields(tagTemplate, $('.participants-tags-filter :selected').text(),
        $('.participants-tags-filter :selected').val());
    $('.participants-filter-tag-selection').append(tagHtml);

    // Reset Tags Selector
    $('.participants-tags-filter').val(null).trigger('change');

    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Remove Tag From Participant Filters
  $('body').on('click', '.users-filter-selection .chip-closeable', function (e) {
    $(this).parent().parent().remove();
    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Challenges Selection in Participant Filter With Auto Suggestion
  $('.participants-challenges-filter').select2({
    placeholder: "Select Challenge",
    tags: true,
    dropdownAutoWidth: true,
    width: '100%'
  }).on("select2:select", function (e) {
    let tagTemplate = $('#participant-filter-tag-template').html();
    let tagHtml = replaceParticipantTagFields(tagTemplate, $('.participants-challenges-filter :selected').text(),
        $('.participants-challenges-filter :selected').val());
    $('.participants-filter-challenges-selection').append(tagHtml);

    // Reset Challenges Selector
    $('.participants-challenges-filter').val(null).trigger('change');

    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Rewards Selection in Participant Filter With Auto Suggestion
  $('.participants-rewards-filter').select2({
    placeholder: "Select Reward",
    tags: true,
    dropdownAutoWidth: true,
    width: '100%'
  }).on("select2:select", function (e) {
    let tagTemplate = $('#participant-filter-tag-template').html();
    let tagHtml = replaceParticipantTagFields(tagTemplate, $('.participants-rewards-filter :selected').text(),
        $('.participants-rewards-filter :selected').val());
    $('.participants-filter-rewards-selection').append(tagHtml);

    // Reset Rewards Selector
    $('.participants-rewards-filter').val(null).trigger('change');

    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Users Age Slider Setup
  let ageFilterSlider = document.getElementById('user-age-filter');
  noUiSlider.create(ageFilterSlider, {
    start: [0, 100],
    connect: true,
    range: {
      'min': 0,
      'max': 100
    }
  });

  ageFilterSlider.noUiSlider.on('update', function (values) {
    $('.filter-min-age').text(parseInt(values[0]));
    $('.filter-max-age').text(parseInt(values[1]));
    applyParticipantFilters(generateParticipantFilterParams());
  });

  //Reset Participant filter checkboxes and update datatable
  $('.reset_user_filters_btn').on('click', function (e) {
    $('input:checkbox').each(function () {
      this.checked = false;
    });
    $('.users-filter-selection').html('');
    ageFilterSlider.noUiSlider.reset();

    applyParticipantFilters(generateParticipantFilterParams());
  });

  // Users Points Slider Setup
  // let sliderWithInput = document.getElementById('slider-with-input');
  // noUiSlider.create(sliderWithInput, {
  //   start: [0, 20000],
  //   connect: true,
  //   range: {
  //     'min': 0,
  //     'max': 20000
  //   }
  // });
  //
  // sliderWithInput.noUiSlider.on('update', function (values, handle) {
  //   $('.filter-min-points').text(parseInt(values[0]));
  //   $('.filter-max-points').text(parseInt(values[1]));
  // });

  // Remove TAG from a Participants
  $('body').on('click', '.remove-participant-tag', function (e) {
    var campaignId = $('.participant-name-container').data('campaign-id');
    var participantId = $('.participant-name-container').data('participant-id');
    var tag = $(this).data('val');
    Swal.fire({
      title: 'Are you sure?',
      text: 'You want to remove this tag?',
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, Remove it!',
      confirmButtonClass: 'btn btn-primary',
      cancelButtonClass: 'btn btn-danger ml-1',
      buttonsStyling: false,
    }).then(function (result) {
      if (result.value) {
        $.ajax({
          url: `/admin/campaigns/${campaignId}/users/${participantId}/remove_tag`,
          type: 'DELETE',
          dataType: 'script',
          data: {
            tag: tag,
            authenticity_token: $('[name="csrf-token"]')[0].content,
          }
        });
      }
    });
  });

  // Add Tag Addition UI from Participant Popup
  $('body').on('click', '.submit-participant-tag', function (e) {
    var campaignId = $('.participant-name-container').data('campaign-id');
    var participantId = $('.participant-name-container').data('participant-id');
    var tag = $('#participant_tags_input').val();

    $.ajax({
      url: `/admin/campaigns/${campaignId}/users/${participantId}/add_tag`,
      type: 'POST',
      dataType: 'script',
      data: {
        tag: tag,
        authenticity_token: $('[name="csrf-token"]')[0].content,
      }
    });
  });

  // Tags Selection With Auto Suggestion
  function initParticipantTagsSelect2() {
    $('.participant-tags').select2({
      placeholder: "Select Tags",
      tags: true,
      dropdownAutoWidth: true,
      width: '50%'
    });
  }
  
  // Add Tag Addition UI from Participant Popup
  $('body').on('click', '.add-tag-btn', function (e) {
    $('.add_tag_btngroup').show();
    initParticipantTagsSelect2();
    $('.add-tag-btn').hide();
  });

  // Remove Tag Addition UI from Participant Popup
  $('body').on('click', '.remove-tag-btn', function (e) {
    $('.add_tag_btngroup').hide();
    $('.participant-tags').val(null).trigger('change');
    $('.add-tag-btn').show();
  });

  // Add Note from Participant Popup
  $('body').on('click', '.submit-note-input', function (e) {
    var campaignId = $('.participant-name-container').data('campaign-id');
    var participantId = $('.participant-name-container').data('participant-id');
    var description = $('#participant_note_description_input').val();
    var errors = 0;
    var description_text = description.trim();
    if (description_text !== '' && description_text !== undefined) {
      $('#note-error').hide();
      $.ajax({
        url: `/admin/campaigns/${campaignId}/users/${participantId}/add_note`,
        type: 'POST',
        dataType: 'script',
        data: {
          description: description,
          authenticity_token: $('[name="csrf-token"]')[0].content,
        }
      });
    } else {
      Swal.fire({
        title: 'Add a Note',
        text: 'Please enter description',
        confirmButtonClass: 'btn btn-primary',
        buttonsStyling: false,
      });
    }
  });

  // Change Participant Status
  $('body').on('click', '.participant-status-dd', function (e) {
    var campaignId = $('.participant-name-container').data('campaign-id');
    var participantId = $('.participant-name-container').data('participant-id');
    var status = $(this).val();

    Swal.fire({
      title: 'Are you sure?',
      text: 'You want to change user status?',
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, Change it!',
      confirmButtonClass: 'btn btn-primary',
      cancelButtonClass: 'btn btn-danger ml-1',
      buttonsStyling: false,
    }).then(function (result) {
      console.log("Result", result);

      if (result.value) {
        $.ajax({
          url: `/admin/campaigns/${campaignId}/users/${participantId}/update_status`,
          type: 'PUT',
          dataType: 'JSON',
          data: {
            authenticity_token: $('[name="csrf-token"]')[0].content,
            status: status
          },
          success: function (data) {
            swalNotify(data.title,  data.message);
          }
        });
      }
    });
  });
});
