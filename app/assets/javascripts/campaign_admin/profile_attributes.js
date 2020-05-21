$(document).on('turbolinks:load', function () {
  // Profile Attributes List
  $('.profile-attribute-list-view').DataTable({
    responsive: false,
    bDestroy: true,
    columnDefs: [
      {
        orderable: true,
        targets: 0,
      }
    ],
    dom:
        '<"top"<"actions action-btns"B><"action-filters"lf>><"clear">rt<"bottom"<"actions">p>',
    oLanguage: {
      sLengthMenu: "_MENU_",
      sSearch: ""
    },
    aLengthMenu: [[5, 10, 15, 20], [5, 10, 15, 20]],
    select: {
      style: "multi"
    },
    order: [[1, "asc"]],
    bInfo: false,
    pageLength: 10,
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add New Profile Attribute",
        action: function() {
          var campignId = $('.profile-attribute-list-view').data('campaign-id');
          window.location.href = `/admin/campaigns/${campignId}/profile_attributes/new`
        },
        className: "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light"
      }
    ],
    initComplete: function(settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary")
    }
  });

  // Edit Profile Attribute Redirection
  $('.profile-attribute-list-view').on('click', '.edit-profile-attribute-btn', function(){
    window.location = $(this).data('url')
  });

  // Add Campaign Form Validation
  $('.profile-attributes-form').validate({
    errorElement: 'span',
    rules: {
      'profile_attribute[attribute_name]': {
        required: true
      },
      'profile_attribute[display_name]': {
        required: true,
      },
      'profile_attribute[field_type]': {
        required: true
      }
    },
    messages: {
      'profile_attribute[attribute_name]': {
        required: 'Please enter attribute name'
      },
      'profile_attribute[display_name]': {
        required: 'Please enter display name'
      },
      'profile_attribute[field_type]': {
        required: 'Please select field type'
      }
    }
  });
});
