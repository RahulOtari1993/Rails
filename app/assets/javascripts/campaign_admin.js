$(document).on('turbolinks:load', function() {
  // Fonts COnfig for Quill Editor
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
      [{ 'color': []}, {'background': []}],
      [{'script': 'super'}, {'script': 'sub'}],
      [{'header': '1'}, {'header': '2'}, 'blockquote', 'code-block'],
      [{'list': 'ordered'}, {'list': 'bullet'}, {'indent': '-1'}, {'indent': '+1'}],
      ['direction', {'align': []}],['link', 'image', 'video', 'formula'],
      ['clean']
    ]},
    theme: 'snow'
  };

  // Add Campaign Form Validation
  $('.edit-campaign-form').validate({
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
    },
    errorPlacement: function(error, element) {
      var placement = $(element).data('error');
      console.log("Placment", placement);
      if (placement) {
        $('.' + placement).append(error)
      } else {
        error.insertAfter(element);
      }
    }
  });

  // Quill Editor Integration for Campaign Rules
  new Quill('.campaign-rules-editor', toolbar);

  // Quill Editor Integration for Campaign Privacy Policy
  new Quill('.campaign-privacy-policy-editor', toolbar);

  // Quill Editor Integration for Campaign Terms of Service
  new Quill('.campaign-terms-editor', toolbar);

  // Quill Editor Integration for Campaign Contact Us
  new Quill('.campaign-contact-us-editor', toolbar);

  // Quill Editor Integration for Campaign FAQ Content
  new Quill('.campaign-faq-content-editor', toolbar);

  // Quill Editor Integration for Campaign General Content
  new Quill('.campaign-general-content-editor', toolbar);

  // Quill Editor Integration for Campaign General Content
  new Quill('.campaign-how-to-earn-content-editor', toolbar);

  // Add Form Details of Quill Editor to Campaign Form Fields
  $('.edit-campaign-form').on('submit', function () {
    $('.rules-txt-area').val($('.campaign-rules-editor .ql-editor').html());
    $('.privacy-txt-area').val($('.campaign-privacy-policy-editor .ql-editor').html());
    $('.terms-txt-area').val($('.campaign-terms-editor .ql-editor').html());
    $('.contact-us-txt-area').val($('.campaign-contact-us-editor .ql-editor').html());
    $('.faq-content-txt-area').val($('.campaign-faq-content-editor .ql-editor').html());
    $('.general-content-txt-area').val($('.campaign-general-content-editor .ql-editor').html());
    $('.how-to-earn-txt-area').val($('.campaign-how-to-earn-content-editor .ql-editor').html());
  });

  // Color Picker Integration
  $('.colour-picker-txt').minicolors({theme: 'bootstrap'})

  $('.reward_listing').on('click', '.download-csv-btn', function(){
    var reward_id = $(this).attr('reward_id')
    var campaign_id = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaign_id + "/rewards/" + reward_id  + "/ajax_user"
    });
  });

  $('.reward_listing').on('click', '.coupon-btn', function(){
    var reward_id = $(this).attr('reward_id')
    var campaign_id = $(this).attr('campaign_id')
    $.ajax({
      type: 'GET',
      data: { authenticity_token: $('[name="csrf-token"]')[0].content},
      url: "/admin/campaigns/" + campaign_id + "/rewards/" + reward_id  + "/ajax_coupon_form"
    });
  });

  //thumbview list
  var dataThumbView = $(".reward_listing").DataTable({
    responsive: false,
    columnDefs: [
      {
        orderable: true,
        targets: 0,
        checkboxes: { selectRow: true }
      }
    ],
    dom:
      '<"top"<"action-filters"lf>><"clear">rt<"bottom"<"actions">p>',
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
        text: "<i class='feather icon-plus'></i> Add Reward",
        action: function() {
          window.location.href = "/admin/campaigns/" + $('.reward_listing').attr('campaign_id') + "/rewards/new"
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

  var form = $(".challenge-wizard");

  $('.challenge-wizard').steps({
    headerTag: "h6",
    bodyTag: "fieldset",
    transitionEffect: "fade",
    titleTemplate: '<span class="step">#index#</span> #title#',
    labels: {
      finish: 'Submit'
    },
    onStepChanging: function (event, currentIndex, newIndex) {
      // Allways allow previous action even if the current form is not valid!
      if (currentIndex > newIndex) {
        return true;
      }

      return form.valid();
    },
    onFinishing: function (event, currentIndex) {
      return form.valid();
    },
    onFinished: function (event, currentIndex) {
      alert("Submitted!");
    }
  });

  $('.challenge-wizard').validate({
    errorElement: 'span',
    rules: {
      'hk_s1_1': {
        required: true
      },
      'hk_s1_2': {
        required: true
      },
      'hk_s2_1': {
        required: true,
        email: true
      },
      'hk_s2_2': {
        required: true,
        email: true
      },
      'hk_s3_1': {
        required: true,
        minlength: 8
      },
      'hk_s4_1': {
        required: true
      },
      'hk_s4_2': {
        required: true
      },
      'hk_s5_1': {
        required: true
      },
    },
    messages: {
      'hk_s1_1': {
        required: 'Please enter first name'
      },
      'hk_s1_2': {
        required: 'Please enter last name'
      },
      'hk_s2_1': {
        required: 'Please enter email address',
        email: 'Please enter valid email address'
      },
      'hk_s2_2': {
        required: 'Please enter confirm email address',
        email: 'Please enter valid email address'
      },
      'hk_s3_1': {
        required: 'Please enter new password',
        minlength: 'Password is too short (minimum is 8 characters)'
      },
      'hk_s4_1': {
        required: 'Please enter first name'
      },
      'hk_s4_2': {
        required: 'Please enter last name'
      },
      'hk_s5_1': {
        required: 'Please enter email address'
      }
    }
  });
});
