$(document).on('turbolinks:load', function () {
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
      $('.challenge-wizard').submit();
    }
  });

  // Get Social Image Dynamically
  function getSocialImageName() {
    if ($('#challenge_platform').val() == 'facebook') {
      imageName = imageNeeded($("#facebookBlockBody input[name='challenge[image]']"));
    } else if ($('#challenge_platform').val() == 'twitter') {
      imageName = imageNeeded($("#twitterBlogBody input[name='challenge[image]']"));
    } else if ($('#challenge_platform').val() == 'linked_in') {
      imageName =imageNeeded($("#linkedinBlogBody input[name='challenge[image]']"));
    } else {
      imageName = ''
    }

    return imageName;
  }

  // Check if social image is needed for Validation
  function imageNeeded(element) {
    return element.hasClass('always-validate') ? element.val() : 'image_not_needed.jpg'
  }

  // Replace ID of Newly Added Fields of User Segment
  function replaceFieldIds(stringDetails, phaseCounter) {
    stringDetails = stringDetails.replace(/\___ID___/g, phaseCounter);
    stringDetails = stringDetails.replace(/___NUM___/g, phaseCounter);
    return stringDetails;
  }

  // Adds Validation for New Added User Segment Fields
  function addValidations(phaseCounter) {
    // Challenge User Segment Conditions Drop Down Require Validation
    $('#segment-conditions-dd-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a condition"
        }
      })
    });

    // Challenge User Segment Age Validation
    $('#segment-value-age-' + phaseCounter).each(function () {
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
    $('#segment-value-points-' + phaseCounter).each(function () {
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
    $('#segment-value-tags-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please enter tag"
        }
      })
    });

    // Challenge User Segment Rewards Validation
    $('#segment-value-rewards-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a reward"
        }
      })
    });

    // Challenge User Segment Platform Validation
    $('#segment-conditions-platforms-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a platform"
        }
      })
    });

    // Challenge User Segment Gender Validation
    $('#segment-value-gender-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select gender"
        }
      })
    });

    // Challenge User Segment Challenge Validation
    $('#segment-value-challenge-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select a challenge"
        }
      })
    });
  }

  // Replace ID of Newly Added Fields of User Segment
  function addSelect2(phaseCounter) {
    // Select2 for Reward Dropdown in User Segment Conditions
    $('#segment-value-rewards-' + phaseCounter).select2({
      dropdownAutoWidth: true,
      width: '100%'
    }).next().hide();

    // Select2 for Challenge Dropdown in User Segment Conditions
    $('#segment-value-challenge-' + phaseCounter).select2({
      dropdownAutoWidth: true,
      width: '100%'
    }).next().hide();
  }

  // Social Blog Image Validator
  $.validator.addMethod('socialImageExistance', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true
    }

    imageName = getSocialImageName()

    if (imageName == "") {
      return false;
    }

    return true;
  }, 'Please select social image');

  // Social Blog Image Extension Validator
  $.validator.addMethod('socialImageExtension', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true
    }

    imageName = getSocialImageName()

    var validImageTypes = ['gif', 'jpeg', 'jpg', 'png'];
    if ($.inArray(imageName.substr((imageName.lastIndexOf('.') + 1)), validImageTypes) < 0) {
      return false;
    }

    return true;
  }, 'Please select valid image');

  // Social Blog Title Validator
  $.validator.addMethod('socialTitle', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('#challenge_platform').val() == 'twitter') {
      return true;
    }

    if ($('#challenge_platform').val() == 'facebook') {
      socialTitle = $("#facebookBlockBody .social-title-txt").val();
    } else if ($('#challenge_platform').val() == 'linked_in') {
      socialTitle = $("#linkedinBlogBody .social-title-txt").val();
    } else {
      socialTitle = ''
    }

    if (socialTitle == "") {
      return false;
    }

    return true;
  }, 'Please enter social title');

  // Social Blog Desctiption Validator
  $.validator.addMethod('socialDesctiption', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('#challenge_platform').val() == 'facebook') {
      socialDescription = $("#facebookBlockBody .social-description-txt").val();
    } else if ($('#challenge_platform').val() == 'twitter') {
      socialDescription = $("#twitterBlogBody .social-description-txt").val();
    } else if ($('#challenge_platform').val() == 'linked_in') {
      socialDescription = $("#linkedinBlogBody .social-description-txt").val();
    } else {
      socialDescription = ''
    }

    if (socialDescription == "") {
      return false;
    }

    return true;
  }, 'Please enter social description');

  $('.challenge-wizard').validate({
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
      'challenge[mechanism]': {
        required: true
      },
      'challenge[name]': {
        required: true
      },
      'challenge[link]': {
        required: true,
        url: true
      },
      'challenge[description]': {
        required: true
      },
      'challenge[points]': {
        required: true,
        digits: true
      },
      'challenge[reward_id]': {
        required: true
      },
      'challenge[image]': {
        socialImageExistance: true,
        socialImageExtension: true
      },
      'social_title': {
        socialTitle: true
      },
      'social_description': {
        socialDesctiption: true
      },
      'challenge_start_date': {
        required: true
      },
      'challenge_start_time': {
        required: true
      },
      'challenge[time_zone]': {
        required: true
      }
    },
    messages: {
      'challenge[mechanism]': {
        required: 'Please select challenge type'
      },
      'challenge[name]': {
        required: 'Please enter challenge name'
      },
      'challenge[link]': {
        required: 'Please enter link to be shared',
        url: 'Please enter valid link'
      },
      'challenge[description]': {
        required: 'Please enter challenge description'
      },
      'challenge[points]': {
        required: 'Please enter points',
        digits: 'Please enter only digits'
      },
      'challenge[reward_id]': {
        required: 'Please enter first name'
      },
      'challenge_start_date': {
        required: 'Please enter start date'
      },
      'challenge_start_time': {
        required: 'Please enter start time'
      },
      'challenge[time_zone]': {
        required: 'Please select timezone'
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

  $('a[data-toggle="pill"]').on('shown.bs.tab', function (e) {
    $(e.target).removeClass('pill-btn');
    $(e.relatedTarget).addClass('pill-btn');

    $('.challenge-wizard .current').removeClass('error');

    if ($(e.target).attr('id') == 'base-rewards-pill') {
      $('#challenge_reward_type').val('prize');
      $('#challenge_reward_id').prop('selectedIndex', 0);
      $('#challenge_reward_id').removeClass('error');
      $('#challenge_reward_id-error').remove();
    }

    if ($(e.target).attr('id') == 'base-points-pill') {
      $('#challenge_reward_type').val('points');
      $('#challenge_points').val('');
      $('#challenge_points').removeClass('error');
      $('#challenge_points-error').remove();
    }
  })

  $('.challenge-type-card').on('click', function (e) {
    $('.challenge-type-card.active').removeClass('active');
    $(this).addClass('active');

    $('#challenge_mechanism').val($(this).data('val'));
  })

  $("#file-input-fb").change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-facebook-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  $("#file-input-twitter").change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-twitter-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  $("#file-input-linkedin").change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-linkedin-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  // Add minus icon for collapse element which is open by default
  $(".collapse.show").each(function () {
    $(this).prev(".card-head").find(".fa").addClass("fa-minus").removeClass("fa-plus");
  });

  // Toggle plus minus icon on show hide of collapse element
  $(".collapse").on('show.bs.collapse', function () {
    $(this).prev(".card-head").find(".fa").removeClass("fa-plus").addClass("fa-minus");
    $('.social-image-error').html('');
    $('.social-title-error').html('');
    $('.social-description-error').html('');
  }).on('hide.bs.collapse', function () {
    $(this).prev(".card-head").find(".fa").removeClass("fa-minus").addClass("fa-plus");
  });

  // Keep One Social Blog Open All the Time
  $('[data-toggle="collapse"]').on('click', function (e) {
    if ($(this).parents('.accordion').find('.collapse.show')) {
      var idx = $(this).index('[data-toggle="collapse"]');

      if (idx == 0) {
        // Facebook
        $('#challenge_platform').val('facebook');
        $("#facebookBlogBody :input").attr('disabled', false);
        $("#twitterBlogBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#facebookBlockBody .social-title-txt").val());
        $('#challenge_social_description').val($("#facebookBlockBody .social-description-txt").val());
      } else if (idx == 1) {
        // Twitter
        $('#challenge_platform').val('twitter');
        $("#twitterBlogBody :input").attr('disabled', false);
        $("#facebookBlogBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#twitterBlogBody .social-title-txt").val());
        $('#challenge_social_description').val($("#twitterBlogBody .social-description-txt").val());
      } else if (idx == 2) {
        // LinkedIn
        $('#challenge_platform').val('linked_in');
        $('#linkedinBlogBody :input').attr('disabled', false);
        $('#facebookBlogBody :input').attr('disabled', true);
        $('#twitterBlogBody :input').attr('disabled', true);

        $('#challenge_social_title').val($("#linkedinBlogBody .social-title-txt").val());
        $('#challenge_social_description').val($("#linkedinBlogBody .social-description-txt").val());
      }

      if (idx == $('.collapse.show').index('.collapse')) {
        // prevent collapse
        e.stopPropagation();
      }
    }
  });

  // Dynamically Change Social Blog Comment Section Details
  $('#challenge_description').keyup(function () {
    $('.user-comment-section').html($(this).val());
  });

  // Add User Segment of Challenges Module
  $('.add-challenge-user-segment').on('click', function (e) {
    let challengeUserSegmentsTemplate = $('#challenge-user-segments-template').html();
    let phaseCounter = Math.floor(Math.random() * 90000) + 10000;

    segmentHtml = replaceFieldIds(challengeUserSegmentsTemplate, phaseCounter);
    $('.campaign-user-segments-container').append(segmentHtml);

    // Add Validation for Newly Added Elements
    addValidations(phaseCounter);

    // Add Select2 Drop Down
    addSelect2(phaseCounter);
  });

  // Remove User Segment of Challenges Module
  $('body').on('click', '.remove-challenge-segment', function (e) {
    $(this).parent().parent().remove();
  });

  // Challenge Event Change Event
  $('body').on('change', '.challenge-event-dd', function (e) {
    var tableRow = $(this).parent().parent();

    // Remove Error Classes of JS Validation & Remove Error Messages
    tableRow.find('span.error').remove();

    // Hide & Disable All the Segmet Condition and Value Fields & Remove Error Class
    tableRow.find('.segment-conditions-container .segment-conditions-dd').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.segment-values-container select').prop('disabled', true).hide().removeClass('error');
    tableRow.find('.segment-values-container input').prop('disabled', true).hide().removeClass('error');

    // Hide Select2 Dropdowns
    tableRow.find('.segment-values-container select').next(".select2-container").hide();

    // Display Segment Condition Drop Downs
    tableRow.find('.segment-conditions-' + $(this).val()).show().removeAttr('disabled');

    // Display Segment Values Inputs / Drop Downs
    tableRow.find('.segment-value-' + $(this).val()).show().removeAttr('disabled');
    tableRow.find('.segment-value-' + $(this).val()).next(".select2-container").show();
  });

  // Change Social Title Value
  $('.social-title-txt').focusout(function () {
    $('#challenge_social_title').val($(this).val());
  });

  // Change Social Link Value
  $('#challenge_link').focusout(function () {
    $('.social-link-label').html($(this).val());
  });

  // Change Social Description Value
  $('.social-description-txt').focusout(function () {
    $('#challenge_social_description').val($(this).val());
  });

  // Date Picker (Disabled all the Past Dates)
  $('.pick-challenge-date').pickadate({
    format: 'mm/d/yyyy',
    selectYears: true,
    selectMonths: true,
    min: true
  });

  // Time Picker
  $('.pick-challenge-time').pickatime();

  // Set Challenge Start Date & Time
  $('body').on('change', '#challenge_start_date', function (e) {
    $('#challenge_start').val($('#challenge_start_date').val() + ' ' + $('#challenge_start_time').val())
  });
  $('body').on('change', '#challenge_start_time', function (e) {
    $('#challenge_start').val($('#challenge_start_date').val() + ' ' + $('#challenge_start_time').val())
  });

  // Set Challenge Finish Date & Time
  $('body').on('change', '#challenge_finish_date', function (e) {
    $('#challenge_finish').val($('#challenge_finish_date').val() + ' ' + $('#challenge_finish_time').val())
  });
  $('body').on('change', '#challenge_finish_time', function (e) {
    $('#challenge_finish').val($('#challenge_finish_date').val() + ' ' + $('#challenge_finish_time').val())
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
    return textString.charAt(0).toUpperCase() + textString.slice(1)
  }

  // Challenges Server Side Listing
  $('#challenge-list-table').DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      "url": "/admin/campaigns/" + $('#challenge-list-table').attr('campaign_id') + "/challenges/fetch_challenges",
      "dataSrc": "challenges",
      dataFilter: function (data) {
        var json = jQuery.parseJSON(data);
        return JSON.stringify(json);
      },
    },
    columns: [
      {
        class: "product-img",
        title: 'Image', data: null, searchable: false,
        render: function (data, type, row) {
          return '<img src="' + data.image['thumb']['url'] + '" />';
        }
      },
      {
        class: 'product-name',
        title: 'Name', data: 'name',
        searchable: true
      },
      {
        class: 'product-name',
        title: 'Social Network',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return textCapitalize(data.platform)
        }
      },
      {
        class: 'product-name',
        title: 'Type',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return textCapitalize(data.mechanism)
        }
      },
      {
        title: 'Start Date', data: null, searchable: false,
        render: function (data, type, row) {
          return formatDate(data.start)
        }
      },
      {
        title: 'End date', data: null, searchable: false,
        render: function (data, type, row) {
          return formatDate(data.finish)
        }
      },
      {
        title: 'Actions', data: null, searchable: false, orderable: false,
        render: function (data, type, row) {
          return "<a href = '/admin/campaigns/" + data.campaign_id + "/challenges/" + data.id + "/edit'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Edit Challenge'" +
              "class='btn btn-icon btn-success mr-1 waves-effect waves-light'><i class='feather icon-edit'></i></a>" +
              "<button class='btn btn-icon btn-warning mr-1 waves-effect waves-light' reward_id ='" + data.id + "'campaign_id='" + data.campaign_id + "'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Download CSV file of challenge participants'>" +
              "<i class='feather icon-download'></i></button>"
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
    // oLanguage: {
    //   sProcessing: "<div class='spinner-border' role='status'><span class='sr-only'></span></div>"
    // },
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add Challenge",
        action: function () {
          window.location.href = "/admin/campaigns/" + $('#challenge-list-table').attr('campaign_id') + "/challenges/new"
        },
        className: "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light"
      }
    ],
    initComplete: function (settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary");
      // $('.dataTables_filter').addClass('search-icon-placement');
    }
  });
  
  // Select2 for Timezone select
  $('#challenge_timezone').select2({
    dropdownAutoWidth: true,
    width: '100%'
  });

  // Select2 for Rewards Selection Dropdown
  $('.reward_id_dd').select2({
    dropdownAutoWidth: true,
    width: '100%'
  });

  // Add Validations on Already Exists User Segments
  setTimeout(function(){
    var ids = $('.existing-filter-ids').data('ids');
    ids.forEach(function(segmentId) {
      addValidations(segmentId)
    });
  }, 2000);
});
