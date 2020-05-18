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
        text: "<i class='feather icon-plus'></i> Add New Campaign",
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

  // // Add Campaign Form Validation
  // $('.edit-campaign-form').validate({
  //   errorElement: 'span',
  //   rules: {
  //     'campaign[name]': {
  //       required: true
  //     },
  //     'campaign[domain]': {
  //       required: true,
  //       domainRegex: true
  //     },
  //     'campaign[domain_type]': {
  //       required: true
  //     }
  //   },
  //   messages: {
  //     'campaign[name]': {
  //       required: 'Please enter campaign name'
  //     },
  //     'campaign[domain]': {
  //       required: 'Please enter campaign domain'
  //     },
  //     'campaign[domain_type]': {
  //       required: 'Please select domain type'
  //     }
  //   },
  //   errorPlacement: function (error, element) {
  //     var placement = $(element).data('error');
  //     console.log("Placment", placement);
  //     if (placement) {
  //       $('.' + placement).append(error)
  //     } else {
  //       error.insertAfter(element);
  //     }
  //   }
  // });
});
