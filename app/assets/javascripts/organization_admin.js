$(document).ready(function() {
  // Invite Organization Admin Form Validation
  $('#new_organizations_user').validate({
    errorElement: 'span',
    rules: {
      'organizations_user[first_name]': {
        required: true
      },
      'organizations_user[last_name]': {
        required: true
      },
      'organizations_user[email]': {
        required: true,
        email: true
      }
    },
    messages: {
      'organizations_user[first_name]': {
        required: 'Please enter organization admin first name'
      },
      'organizations_user[last_name]': {
        required: 'Please enter organization admin last name'
      },
      'organizations_user[email]': {
        required: 'Please enter organization admin email',
        email: 'Please enter valid organization admin email'
      }
    }
  });

  // Add Campaign Form Validation
  $('.add-campaign-form').validate({
    errorElement: 'span',
    rules: {
      'campaign[name]': {
        required: true
      },
      'campaign[domain]': {
        required: true,
        domainRegex: true
      },
      'campaign[domain_type]': {
        required: true
      }
    },
    messages: {
      'campaign[name]': {
        required: 'Please enter campaign name'
      },
      'campaign[domain]': {
        required: 'Please enter campaign domain'
      },
      'campaign[domain_type]': {
        required: 'Please select domain type'
      }
    }
  });

  var dataListView = $(".campaign-list-view").DataTable({
    responsive: false,
    columnDefs: [
      {
        orderable: true,
        targets: 0,
        checkboxes: { selectRow: true }
      }
    ],
    dom:
      '<"top"<"actions action-btns"B><"action-filters"lf>><"clear">rt<"bottom"<"actions">p>',
    oLanguage: {
      sLengthMenu: "_MENU_",
      sSearch: ""
    },
    aLengthMenu: [[4, 10, 15, 20], [4, 10, 15, 20]],
    select: {
      style: "multi"
    },
    order: [[1, "asc"]],
    bInfo: false,
    pageLength: 4,
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add New Campaign",
        action: function() {
          window.location.href = '/admin/organizations/campaigns/new'
        },
        className: "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light" // btn-outline-primary
      }
    ],
    initComplete: function(settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary")
    }
  });

  dataListView.on('draw.dt', function(){
    setTimeout(function(){
      if (navigator.userAgent.indexOf("Mac OS X") != -1) {
        $(".dt-checkboxes-cell input, .dt-checkboxes").addClass("mac-checkbox")
      }
    }, 50);
  });
});
