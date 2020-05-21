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
    if ($('#challenge_parameters').val() == 'facebook') {
      imageName = imageNeeded($("#facebookBlockBody input[name='challenge[social_image]']"));
    } else if ($('#challenge_parameters').val() == 'twitter') {
      imageName = imageNeeded($("#twitterBlogBody input[name='challenge[social_image]']"));
    } else if ($('#challenge_parameters').val() == 'linked_in') {
      imageName = imageNeeded($("#linkedinBlogBody input[name='challenge[social_image]']"));
    } else {
      imageName = ''
    }

    return imageName;
  }

  // Check if social image is needed for Validation
  function imageNeeded(element) {
    return element.hasClass('always-validate') ? element.val() : 'image_not_needed.jpg'
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

  // Used to Manage Step Two UI Components
  function stepTwoContent(challengeType, challengeParameters) {
    $('.step-two-container').hide();
    $('.step-two-container').removeClass('active-segment');
    $('.step-two-container input').prop("disabled", true);
    $('.step-two-container select').prop("disabled", true);
    $('.step-two-container hidden').prop("disabled", true);

    $('.' + challengeType + '-' + challengeParameters + '-div').show();
    $('.' + challengeType + '-' + challengeParameters + '-div').addClass('active-segment');
    $('.' + challengeType + '-' + challengeParameters + '-div input').prop("disabled", false);
    $('.' + challengeType + '-' + challengeParameters + '-div select').prop("disabled", false);
    $('.' + challengeType + '-' + challengeParameters + '-div hidden').prop("disabled", false);

    // Disable Question Builder Inputs
    if (challengeType == 'collect' && challengeParameters == 'profile') {
      $('.' + challengeType + '-' + challengeParameters + '-div .disabled-field').prop("disabled", true);
    }

    // Load Google Map if Challenge Type is Location
    if (challengeType == 'location') initAutocomplete()

    if (challengeType == 'share' && challengeParameters == 'facebook') {
      $('.share-facebook-div .social-title-txt').addClass('always-validate');
      $('.share-twitter-div .social-description-txt').removeClass('always-validate');
    } else if (challengeType == 'share' && challengeParameters == 'twitter') {
      $('.share-twitter-div .social-description-txt').addClass('always-validate');
      $('.share-facebook-div .social-description-txt').removeClass('always-validate');
    }
  }

  // Trigger Raduis Calculation
  if (window.location.href.indexOf("edit") > -1) {
    setTimeout(function () {
      if ($('.step-two-container.active-segment').hasClass('location--div')) {
        $('#challenge_location_distance').trigger('change');
      }
    }, 2000);
  }

  // Social Blog Image Validator
  $.validator.addMethod('socialImageExistance', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true
    }

    if ($('.step-two-container').hasClass('share-facebook-div') || $('.step-two-container').hasClass('share-twitter-div')) {
      imageName = getSocialImageName()

      if (imageName == "") {
        return false;
      }
    } else {
      return true;
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

    if ($('.step-two-container').hasClass('share-facebook-div') || $('.step-two-container').hasClass('share-twitter-div')) {
      imageName = getSocialImageName()

      var validImageTypes = ['gif', 'jpeg', 'jpg', 'png'];
      if ($.inArray(imageName.substr((imageName.lastIndexOf('.') + 1)), validImageTypes) < 0) {
        return false;
      }
    } else {
      return true;
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

    if ($('#challenge_parameters').val() == 'twitter') {
      return true;
    }

    if ($('#challenge_parameters').val() == 'facebook') {
      socialTitle = $("#facebookBlockBody .social-title-txt").val();
    } else if ($('#challenge_parameters').val() == 'linked_in') {
      socialTitle = $("#linkedinBlogBody .social-title-txt").val();
    } else {
      socialTitle = ''
    }

    if (socialTitle == "") {
      return false;
    }

    return true;
  }, 'Please enter social title');

  //Social Blog Desctiption Validator
  $.validator.addMethod('socialDesctiption', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('#challenge_parameters').val() == 'facebook') {
      socialDescription = $("#facebookBlockBody .social-description-txt").val();
    } else if ($('#challenge_parameters').val() == 'twitter') {
      socialDescription = $("#twitterBlogBody .social-description-txt").val();
    } else if ($('#challenge_parameters').val() == 'linked_in') {
      socialDescription = $("#linkedinBlogBody .social-description-txt").val();
    } else {
      socialDescription = ''
    }

    if (socialDescription == "") {
      return false;
    }

    return true;
  }, 'Please enter social description');

  // Validator Title Elements
  $.validator.addMethod('titleElement', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('.step-two-container.video-youtube-div').hasClass('active-segment') ||
        $('.step-two-container.link--div').hasClass('active-segment')) {

      if (value == "") {
        return false;
      }
    } else {
      return true;
    }

    return true;
  }, 'Please enter valid title');

  // Validator Content Elements
  $.validator.addMethod('contentElement', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('.step-two-container.article--div').hasClass('active-segment')) {

      if (value == "") {
        return false;
      }
    } else {
      return true;
    }

    return true;
  }, 'Please enter content');

  //  Validator Location Elements
  $.validator.addMethod('latLonElement', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    if ($('.step-two-container.location--div').hasClass('active-segment')) {

      if (value == "") {
        return false;
      }
    } else {
      return true;
    }

    return true;
  }, 'Please select valid address');

  $('.challenge-wizard').validate({
    errorElement: 'span',
    onfocusout: function (element) {
      return false;
    },
    ignore: function (index, el) {
      var $el = $(el);

      if ($el.hasClass('always-validate')) {
        return false;
      }

      // Default behavior
      return $el.is(':hidden') || $el.hasClass('ignore');
    },
    rules: {
      'challenge[challenge_type]': {
        required: true
      },
      'challenge[name]': {
        required: true
      },
      'challenge[description]': {
        required: true
      },
      'challenge[image]': {
        required: true,
        extension: "jpg|jpeg|png|gif"
      },
      'challenge[link]': {
        required: true,
        url: true
      },
      'challenge[points]': {
        required: true,
        digits: true
      },
      'challenge[reward_id]': {
        required: true
      },
      'challenge[spcial_image]': {
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
      },
      'challenge[title]': {
        titleElement: true
      },
      'challenge[duration]': {
        titleElement: true,
        digits: true
      },
      'challenge[content]': {
        contentElement: true
      },
      'challenge[address]': {
        required: true
      },
      'challenge[location_distance]': {
        required: true
      },
      'challenge[longitude]': {
        latLonElement: true
      },
      'challenge[latitude]': {
        latLonElement: true
      }
    },
    messages: {
      'challenge[challenge_type]': {
        required: 'Please select challenge type'
      },
      'challenge[name]': {
        required: 'Please enter challenge name'
      },
      'challenge[description]': {
        required: 'Please enter challenge description'
      },
      'challenge[image]': {
        required: 'Please select challenge photo',
        extension: 'Please select challenge photo with valid extension'
      },
      'challenge[link]': {
        required: 'Please enter valid link',
        url: 'Please enter valid link'
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
      },
      'challenge[duration]': {
        required: 'Please enter duration in seconds',
        digits: 'Please enter duration in seconds'
      },
      'challenge[address]': {
        required: 'Please enter address'
      },
      'challenge[location_distance]': {
        required: 'Please select location radius'
      }
    },
    errorPlacement: function (error, element) {
      var placement = $(element).data('error');
      if (placement) {
        $('.' + placement).html(error)
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
  });

  // Wizard Step 1 Chalenge Type Selection Changes
  $('.challenge-type-list').on('click', function (e) {
    $('.add-challenge-form').trigger("reset");
    $('.challenge-type-list.active').removeClass('active');
    $(this).addClass('active');

    $('#challenge_challenge_type').val($(this).data('challenge-type'));
    $('#challenge_parameters').val($(this).data('challenge-parameters'));
    $('#challenge_category').val($(this).parents().eq(5).data('val'));

    stepTwoContent($(this).data('challenge-type'), $(this).data('challenge-parameters'))
  });

  // For Edit Challenge Trigger Click for Challenge Type
  $('.challenge-type-list.active').trigger('click');

  $('#file-input-fb').change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-facebook-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  $('#file-input-twitter').change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-twitter-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  $('#file-input-linkedin').change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#show-linkedin-image').attr('src', e.target.result);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });

  // Add minus icon for collapse element which is open by default
  $('.collapse.show').each(function () {
    $(this).prev(".card-head").find(".fa").addClass("fa-minus").removeClass("fa-plus");
  });

  // Toggle plus minus icon on show hide of collapse element
  $('.collapse').on('show.bs.collapse', function () {
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
        $('#challenge_parameters').val('facebook');
        $("#facebookBlogBody :input").attr('disabled', false);
        $("#twitterBlogBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#facebookBlockBody .social-title-txt").val());
        $('#challenge_social_description').val($("#facebookBlockBody .social-description-txt").val());
      } else if (idx == 1) {
        // Twitter
        $('#challenge_parameters').val('twitter');
        $("#twitterBlogBody :input").attr('disabled', false);
        $("#facebookBlogBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#twitterBlogBody .social-title-txt").val());
        $('#challenge_social_description').val($("#twitterBlogBody .social-description-txt").val());
      } else if (idx == 2) {
        // LinkedIn
        $('#challenge_parameters').val('linked_in');
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
    console.log("$(this).val()", $(this).val())
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
    if (textString) {
      return textString.charAt(0).toUpperCase() + textString.slice(1)
    } else {
      return ''
    }
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
          html = ''
          if (data.status == 'draft') {
            html = '<i class="data_table_status_icon fa fa-circle-o fa_draft fa_circle_sm" aria-hidden="true"></i>';
          } else if (data.status == 'active') {
            html = '<i class="data_table_status_icon fa fa-circle fa_active fa_circle_sm" aria-hidden="true"></i>';
          } else if (data.status == 'scheduled') {
            html = '<i class="data_table_status_icon fa fa-circle-o fa_scheduled fa_circle_sm" aria-hidden="true"></i>'
          } else {
            html = '<i class="data_table_status_icon fa fa-circle fa_ended fa_circle_sm" aria-hidden="true"></i>'
          }
          html += '<img src="' + data.image['thumb']['url'] + '" style="margin-left:20px;" />'
          return html
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
          return '<span class="challenge-name" data-challenge-id="' + data.id + '" data-campaign-id="' + data.campaign_id + '">' + data.name + '</span>'
        }
      },
      {
        class: 'product-name',
        title: 'Social Network',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return textCapitalize(data.parameters)
        }
      },
      {
        class: 'product-name',
        title: 'Type',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return textCapitalize(data.challenge_type)
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
        class: 'product-action a',
        title: 'Actions', data: null, searchable: false, orderable: false,
        render: function (data, type, row) {
          actionText = data.is_approved ? ' Disable' : ' Approve'

          return "<div class='input-group' data-challenge-id ='" + data.id + "' data-campaign-id='" + data.campaign_id + "'>" +
              "<span class='dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='true'><i class='feather icon-more-horizontal'></i></span>" +
              "<div class='dropdown-menu more_action_bg' x-placement='bottom-end' style='position: absolute;z-index: 9999;'>" +
              "<a class='dropdown-item' href='javascript:void(0);'><i class='feather icon-trending-up'></i> Stats</a>" +
              "<a class='dropdown-item' href = '/admin/campaigns/" + data.campaign_id + "/challenges/" + data.id + "/edit'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Edit Challenge'>" +
              "<i class='feather icon-edit-2'></i> Edit</a>" +
              "<a class='dropdown-item display-challenge-participants' href='javascript:void(0);'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Download CSV file of challenge participants'>" +
              "<i class='feather icon-download'></i> Download CSV</a>" +
              "<a class='dropdown-item clone-challenge' href='javascript:void(0);'><i class='feather icon-copy'></i> Duplicate</a>" +
              "<a class='dropdown-item toggle-challenge-status' href='javascript:void(0);'><i class='feather icon-check-square'></i> " + actionText + "</a>" +
              "</div>" +
              "</div>"
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
  setTimeout(function () {
    var ids = $('.existing-filter-ids').data('ids');
    if (ids) {
      ids.forEach(function (segmentId) {
        addValidations(segmentId)
      });
    }
  }, 2000);

  // Open Popup for Challenge Participants
  $('#challenge-list-table').on('click', '.display-challenge-participants', function () {
    var challengeId = $(this).parent().parent().data('challenge-id');
    var campaignId = $(this).parent().parent().data('campaign-id');
    $.ajax({
      type: 'GET',
      url: "/admin/campaigns/" + campaignId + "/challenges/" + challengeId + "/participants"
    });
  });

  // Open Popup for Challenge Details
  $('#challenge-list-table').on('click', '.challenge-name', function () {
    var challengeId = $(this).data('challenge-id');
    var campaignId = $(this).data('campaign-id');
    $.ajax({
      type: 'GET',
      url: "/admin/campaigns/" + campaignId + "/challenges/" + challengeId
    });
  });

  // Clone & Duplicate a Challenge
  $('#challenge-list-table').on('click', '.clone-challenge', function () {
    var challengeId = $(this).parent().parent().data('challenge-id');
    var campaignId = $(this).parent().parent().data('campaign-id');

    Swal.fire({
      title: 'Are you sure?',
      text: 'You want to duplicate this challenge?',
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, Duplicate it!',
      confirmButtonClass: 'btn btn-primary',
      cancelButtonClass: 'btn btn-danger ml-1',
      buttonsStyling: false,
    }).then(function (result) {
      if (result.value) {
        $('.loader').fadeIn(500);
        $.ajax({
          type: 'GET',
          url: "/admin/campaigns/" + campaignId + "/challenges/" + challengeId + "/duplicate",
          success: function (data) {
            $('.loader').fadeOut(500);
            swalNotify(data.title, data.message);

            if (data.success) {
              $('#challenge-list-table').DataTable().ajax.reload(null, false);
            }
          }
        });
      }
    });
  });

  // Clone & Duplicate a Challenge
  $('#challenge-list-table').on('click', '.toggle-challenge-status', function () {
    var challengeId = $(this).parent().parent().data('challenge-id');
    var campaignId = $(this).parent().parent().data('campaign-id');

    if ($(this).html().includes('Approve')) {
      swalTitle = 'Approve'
      swalText = 'You want to approve this challenge?'
    } else {
      swalTitle = 'Disable'
      swalText = 'You want to disable this challenge?'
    }

    Swal.fire({
      title: 'Are you sure?',
      text: swalText,
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, ' + swalTitle + ' it!',
      confirmButtonClass: 'btn btn-primary',
      cancelButtonClass: 'btn btn-danger ml-1',
      buttonsStyling: false,
    }).then(function (result) {
      if (result.value) {
        $('.loader').fadeIn();
        $.ajax({
          type: 'GET',
          url: "/admin/campaigns/" + campaignId + "/challenges/" + challengeId + "/toggle",
          success: function (data) {
            $('.loader').fadeOut();
            swalNotify(data.title, data.message);
            if (data.success) {
              $('#challenge-list-table').DataTable().ajax.reload(null, false);
            }
          }
        });
      }
    });
  });

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

  // Quill Editor Integration for Challenge Articles
  new Quill('.article-content-editor', toolbar);

  // Add Quill Editor's Content to Actual Element
  $('.article-content-editor').focusout(function () {
    $('.article-content-txt-area').val($('.article-content-editor .ql-editor').html());
  });

  var mapCircle = [];

  function initAutocomplete() {
    var map = new google.maps.Map(document.getElementById('location-challenge-map'), {
      center: {lat: -33.8688, lng: 151.2195},
      zoom: 8,
      // mapTypeId: 'roadmap'
    });

    // Create the search box and link it to the UI element.
    var input = document.getElementById('location-selection-input');
    var searchBox = new google.maps.places.SearchBox(input);
    // map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function () {
      searchBox.setBounds(map.getBounds());
    });

    var markers = [];
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function () {
      var places = searchBox.getPlaces();
      var locations = []
      if (places.length == 0) {
        $('#location-selection-input').val('');
        $('.location-longitude').val('');
        $('.location-latitude').val('');
        return;
      } else {
        locations.push(places[0])
      }

      // Clear out the old Markers & Circles.
      markers.forEach(function (marker) {
        marker.setMap(null);
      });
      mapCircle.forEach(function (mCircle) {
        mCircle.setMap(null);
      });

      markers = [];
      mapCircle = [];

      // For each place, get the icon, name and location.
      var bounds = new google.maps.LatLngBounds();

      places.forEach(function (place) {
        if (!place.geometry) {
          console.log("Returned place contains no geometry");
          return;
        }
        var icon = {
          url: place.icon,
          size: new google.maps.Size(71, 71),
          origin: new google.maps.Point(0, 0),
          anchor: new google.maps.Point(17, 34),
          scaledSize: new google.maps.Size(25, 25)
        };

        // Create a marker for each place.
        markers.push(new google.maps.Marker({
          map: map,
          // icon: icon,
          // title: place.name,
          position: place.geometry.location
        }));

        var latLon = place.geometry.location.toJSON();
        $('.location-latitude').val(latLon.lat);
        $('.location-longitude').val(latLon.lng);

        if ($('#challenge_location_distance').val()) {
          // Draw a Radius around the selected address
          mapCircle.push(new google.maps.Circle({
            strokeColor: '#FF0000',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#FF0000',
            fillOpacity: 0.35,
            map: map,
            center: {lat: parseFloat($('.location-latitude').val()), lng: parseFloat($('.location-longitude').val())},
            radius: parseFloat($('#challenge_location_distance').val())
          }));
        }

        if (place.geometry.viewport) {
          // Only geocodes have viewport.
          bounds.union(place.geometry.viewport);
        } else {
          bounds.extend(place.geometry.location);
        }
      });
      map.fitBounds(bounds);
      $('#challenge_location_distance').trigger('change');
    });
  }

  // Draw a Radius on Challenge Radius Change
  $('#challenge_location_distance').on('change', function (e) {
    if (parseFloat($('.location-latitude').val()) != 0 && parseFloat($('.location-longitude').val()) != 0 && $('#challenge_location_distance').val()) {
      var latLon = {lat: parseFloat($('.location-latitude').val()), lng: parseFloat($('.location-longitude').val())};

      var map = new google.maps.Map(document.getElementById('location-challenge-map'), {
        center: latLon,
        zoom: 10,
        maxZoom: 15
      });

      var bounds = new google.maps.LatLngBounds();

      new google.maps.Marker({
        map: map,
        position: latLon
      });

      mapCircle.push(new google.maps.Circle({
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35,
        map: map,
        center: latLon,
        radius: parseFloat($('#challenge_location_distance').val())
      }));

      bounds.extend(latLon);
      map.fitBounds(bounds);
    }
  })

  // Generates Challenge Filter Query String
  function generateFilterParams() {
    var status_checked = []
    var type_checked = []
    var platform_checked = []
    var reward_checked = []
    var tags = []
    var filter = {}
    $("input[name='filters[status][]']:checked").each(function () {
      status_checked.push($(this).parent().find('.filter_label').html());
    });
    filter["status"] = status_checked
    $("input[name='filters[challenge_type][]']:checked").each(function () {
      type_checked.push($(this).parent().find('.filter_label').html());
    });
    filter['challenge_type'] = type_checked
    $("input[name='filters[platform_type][]']:checked").each(function () {
      platform_checked.push($(this).parent().find('.filter_label').html());
    });
    filter['platform_type'] = platform_checked
    $("input[name='filters[reward_type][]']:checked").each(function () {
      reward_checked.push($(this).parent().find('.filter_label').html());
    });
    filter['reward_type'] = reward_checked

    $('.challenge-tags-filter-chip').each(function () {
      tags.push($(this).data('tag-val'));
    });
    filter['tags'] = tags

    return filter;
  }

  // Applly Challenge Filters
  function applyFilters(filters) {
    if (filters != '') {
      $('#challenge-list-table').DataTable().ajax.url(
          "/admin/campaigns/" + $('#challenge-list-table').attr('campaign_id') + "/challenges/fetch_challenges"
          + "?filters=" + JSON.stringify(filters)
      )
          .load() //checked
    } else {
      $('#challenge-list-table').DataTable().ajax.reload();
    }
  }

  // Challenge sidebar status filters
  $('.challenge_sidebar_filter').change(function () {
    applyFilters(generateFilterParams());
  });

  $('.challenge-tags-form').select2({
    placeholder: "Select Tags",
    tags: true,
    dropdownAutoWidth: true,
    width: '70%'
  });

  // Tags Selection With Auto Suggestion
  function initChallengeTagsSelect2() {
    $('.challenge-tags').select2({
      placeholder: "Select Tags",
      tags: true,
      dropdownAutoWidth: true,
      width: '50%'
    });
  }

  // Load Challenge Image on Selection
  $('#challenge_image').change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#challenge-image-preview').attr('src', e.target.result);
        $('#challenge_image').removeClass('ignore'); // Remove Igonore Class to Validate New Uploaded Image
      }
      reader.readAsDataURL(this.files[0]);
    }
  });

  // Remove TAG from a Challenges
  $('body').on('click', '.remove-challenge-tag', function (e) {
    var campaignId = $('.challenge-name-container').data('campaign-id');
    var challengeId = $('.challenge-name-container').data('challenge-id');
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
          url: `/admin/campaigns/${campaignId}/challenges/${challengeId}/remove_tag`,
          type: 'POST',
          dataType: 'script',
          data: {
            tag: tag,
            authenticity_token: $('[name="csrf-token"]')[0].content,
          }
        });
      }
    });
  });

  // Add Tag Addition UI from Challenge Popup
  $('body').on('click', '.add-tag-btn', function (e) {
    $('.add_tag_btngroup').show();
    initChallengeTagsSelect2();
    $('.add-tag-btn').hide();
  });

  // Remove Tag Addition UI from Challenge Popup
  $('body').on('click', '.remove-tag-btn', function (e) {
    $('.add_tag_btngroup').hide();
    $('.challenge-tags').val(null).trigger('change');
    $('.add-tag-btn').show();
  });

  // Add Tag Addition UI from Challenge Popup
  $('body').on('click', '.submit-challenge-tag', function (e) {
    var campaignId = $('.challenge-name-container').data('campaign-id');
    var challengeId = $('.challenge-name-container').data('challenge-id');
    var tag = $('#challenge_tags_input').val();

    $.ajax({
      url: `/admin/campaigns/${campaignId}/challenges/${challengeId}/add_tag`,
      type: 'POST',
      dataType: 'script',
      data: {
        tag: tag,
        authenticity_token: $('[name="csrf-token"]')[0].content,
      }
    });
  });

  // Add Tag Addition UI from Challenge Popup
  $('body').on('click', '#challenge_filter_applied', function (e) {
    if ($('#challenge_filter_applied').is(":checked")) {
      $('.filters-container').show();
      $('.campaign-user-segments-container input').prop('disabled', false);
      $('.campaign-user-segments-container select').prop('disabled', false);
    } else {
      $('.campaign-user-segments-container input').prop('disabled', true);
      $('.campaign-user-segments-container select').prop('disabled', true);
      $('.filters-container').hide();
    }
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

  // Tags Selection in Challenge Filter With Auto Suggestion
  $('.challenge-tags-filter').select2({
    placeholder: "Select Tag",
    tags: true,
    dropdownAutoWidth: true,
  }).on("select2:select", function (e) {
    let tagTemplate = $('#filter-tag-template').html();
    tagHtml = replaceTagFields(tagTemplate, $('.challenge-tags-filter :selected').text(), $('.challenge-tags-filter :selected').val());
    $('.challenge-filter-tag-selection').append(tagHtml);

    // Reset Tags Selector
    $('.challenge-tags-filter').val(null).trigger('change');

    applyFilters(generateFilterParams());
  });

  // Remove Tag From Challenge Filters
  $('body').on('click', '.challenge-filter-tag-selection .chip-closeable', function (e) {
    $(this).parent().parent().remove();
    applyFilters(generateFilterParams());
  });

  //Reset filter checkboxes and update datatable
  $('.reset_challenge_filter_checkboxes').on('click', function (e) {
    $('input:checkbox').each(function () {
      this.checked = false;
    });
    $('.challenge-filter-tag-selection').html('');

    applyFilters(generateFilterParams());

    // $('#challenge-list-table').DataTable().ajax.url(
    //     "/admin/campaigns/" + $('#challenge-list-table').attr('campaign_id') + "/challenges/fetch_challenges"
    // ).load()
  });

  // Dropdown Formate Icon
  function iconFormat(icon) {
    var originalOption = icon.element;
    if (!icon.id) {
      return icon.text;
    }
    var $icon = "<i class='" + $(icon.element).data('icon') + "'></i>" + icon.text;

    return $icon;
  };

  // Select2 Inititalization for Dropdown Format Icon
  function questionTypeSelect2(phaseCounter = '') {
    if (phaseCounter != '') {
      var dropdownID = '-' + phaseCounter;
    } else {
      var dropdownID = '';
    }

    console.log("DD ID", dropdownID);

    $(`.question-selector${dropdownID}`).select2({
      dropdownAutoWidth: true,
      width: '100%',
      minimumResultsForSearch: Infinity,
      templateResult: iconFormat,
      templateSelection: iconFormat,
      escapeMarkup: function (es) {
        return es;
      }
    })
    //     .on('select2:select', function (e) {
    //   var selectedVal = $(`.question-selector${dropdownID} :selected`).val();
    //   var customId = $(this).data('custom-id');
    //   console.log("Selected Val",selectedVal, customId);
    //
    //   $(`.question-box${customId} .options-container`).hide();
    //   $(`.question-box${customId} .${selectedVal}-container`).show();
    // });
  };

  // Question Selector Dropdown
  questionTypeSelect2();

  // Replace ID of Newly Added Fields of Challenge Question
  function replaceQuestionContainerFieldIds(stringDetails, phaseCounter, optionCounter) {
    stringDetails = stringDetails.replace(/\___CLASS___/g, phaseCounter);
    stringDetails = stringDetails.replace(/\___NUM___/g, phaseCounter);
    stringDetails = stringDetails.replace(/\___ID___/g, phaseCounter);

    stringDetails = stringDetails.replace(/\___O_ID___/g, optionCounter);
    return stringDetails;
  }

  // Add New Question
  $('.add-challenge-question').on('click', function (e) {
    let questionTemplate = $('#question-template').html();
    let phaseCounter = Math.floor(Math.random() * 90000) + 10000;
    let optionCounter = Math.floor(Math.random() * 90000) + 10000;

    questionHtml = replaceQuestionContainerFieldIds(questionTemplate, phaseCounter, optionCounter);
    $('.questions-container').append(questionHtml);

    // Question Selector Dropdown
    questionTypeSelect2(phaseCounter);
  });

  // Manage Auto Selection of Text
  function autoSelectText() {
    $('.options-container input').click(function () {
      $(this).select();
    });
  };

  // Show Hide Question Options Dynamically
  $('body').on('change', '.question-selector', function (e) {
    var selectedVal = $(this).val();
    var customId = $(this).data('custom-id');

    $(`.question-box${customId} .options-container`).hide();
    $(`.question-box${customId} .options-container input`).prop('disabled', true);

    $(`.question-box${customId} .${selectedVal}-container`).show();
    $(`.question-box${customId} .${selectedVal}-container .is-editable`).prop('disabled', false);
    autoSelectText();
  });

  // Remove Question With Validation
  $('body').on('click', '.question_del_icon', function (e) {
    console.log("Length", $('.question_del_icon').length);
    if ($('.question_del_icon').length > 1) {
      $(this).parent().parent().parent().parent().remove();
    } else {
      swalNotify('Remove Question', 'You can not remove all questions, Atleast one question needed.');
    }
  });

  // Remove Question Option With Validation
  $('body').on('click', '.que_edit_cross', function (e) {
    var options = $(this).parent().parent().find('.que_edit').length

    if (options > 2) {
      $(this).parent().remove();
    } else {
      swalNotify('Remove Option', 'You can not remove all options, Atleast one option needed.');
    }
  });

  // Add New Option to a Question
  $('body').on('click', '.add-challenge-option', function (e) {
    var optionHtml = $(this).parent().parent().parent().find('.que_edit').first().html();
    optionHtml = optionHtml.replace("Option 1", "New Option");
    $('<div class="que_edit">' + optionHtml + '</div>').insertBefore($(this).parent().parent());

    autoSelectText();
  });
});
