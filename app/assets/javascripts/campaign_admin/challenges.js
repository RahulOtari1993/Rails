$(document).on('turbolinks:load', function () {
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

  var form = $(".challenge-wizard");

  var stepsWizard = $('.challenge-wizard').steps({
    headerTag: "h6",
    bodyTag: "fieldset",
    transitionEffect: "fade",
    enableKeyNavigation: false,
    // suppressPaginationOnFocus: true,
    titleTemplate: '<span class="step">#index#</span> #title#',
    labels: {
      finish: 'Submit'
    },
    onInit: function (event, currentIndex) {
      // if ($('.new_challenge_section').data('form-type') == 'edit') {
      //   $('.challenge-wizard').steps("next");
      // }
    },
    onStepChanging: function (event, currentIndex, newIndex) {
      // Disable Key Navigations for Quill Editor
      $('body').on('keydown', '.ql-editor', function (e) {
        let key = e.key; // Fetch the Key Event

        if (key == "ArrowRight" || key == "ArrowLeft") {
          return false;
        }
      });

      // Always allow previous action even if the current form is not valid!
      if ($('.new_challenge_section').data('form-type') == 'edit') {
        // While Editing a Challenge Stop User to Jump on Step 1
        if (currentIndex == 1 && newIndex == 0) {
          return false;
        }
      }

      if ((currentIndex == 1 && newIndex == 2)) {
        if ($('.challenge-type-list.active').data('challenge-type') == 'engage' && ($('.challenge-type-list.active').data('challenge-parameters') == 'facebook' || $('.challenge-type-list.active').data('challenge-parameters') == 'instagram')) {
          console.log("SKIP THIS STEP");
          // $('#steps-uid-0-t-3').click();
          // stepsWizard.steps("next");
          // return;
        }
      }

      if ((currentIndex == 3 && newIndex == 2)) {
        if ($('.challenge-type-list.active').data('challenge-type') == 'engage' && ($('.challenge-type-list.active').data('challenge-parameters') == 'facebook' || $('.challenge-type-list.active').data('challenge-parameters') == 'instagram')) {
          console.log("SKIP THIS STEP");
          // $('.challenge-wizard').steps("previous");
          // return;
          // $('#steps-uid-0-t-1').click();
        }
      }

      if (currentIndex > newIndex) {
        return true;
      }

      return form.valid();
    },
    onFinishing: function (event, currentIndex) {
      return form.valid();
    },
    onFinished: function (event, currentIndex) {
      // Pass Quill Editor Details to Form
      var challengeType = $('#challenge_challenge_type').val();
      var challengeParameters = $('#challenge_parameters').val();

      if ($(`.${challengeType}-${challengeParameters}-div .question-wysiwyg-editor`).length > 0 ) {
        $(`.${challengeType}-${challengeParameters}-div .question-wysiwyg-editor`).each(function (index) {
          if ($(this).hasClass('display-editor')) {
            $(`.details-question-wysiwyg-editor${$(this).data('editor-identifire')}`).val($(`.question-wysiwyg-editor${$(this).data('editor-identifire')} .ql-editor`).html());
          }
        });
      }

      $('.challenge-wizard').submit();
    }
  });

  var step3HeaderDiv =  $('.steps > ul > li')[2];
  var step3ChallengeDiv =  $('.step3-content-div').html();

  // Get Social Image Dynamically
  function getSocialImageName() {
    if ($('#challenge_parameters').val() == 'facebook') {
      imageName = imageNeeded($("#facebookBlockBody input[name='challenge[social_image]']"));
    } else if ($('#challenge_parameters').val() == 'twitter') {
      imageName = imageNeeded($("#twitterBlockBody input[name='challenge[social_image]']"));
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

  // Trigger SWAL Notification
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

  // Add Validations for Question Fields
  function addOptionValidations() {
    // Validation for Question
    $('.question-field-req').each(function () {
      $(this).rules('add', {
        required: true,
        messages: {
          required: "Please enter question"
        }
      })
    });

    // Validation for Option
    $('.option-req-field').each(function () {
      $(this).rules('add', {
        required: true,
        messages: {
          required: "Please enter option value"
        }
      })
    });

    // Validation for Image Option
    $('.image-uploader-control').each(function () {
      $(this).rules('add', {
        required: true,
        messages: {
          required: "Please select image for option"
        }
      })
    });
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

    // Challenge User Segment Current Points Validation
    $('#segment-value-current-points-' + phaseCounter).each(function () {
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

    // Challenge User Segment Lifetime Points Validation
    $('#segment-value-lifetime-points-' + phaseCounter).each(function () {
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

    // Challenge User Segment Challenges Completed Validation
    $('#segment-value-challenge-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 10000,
        digits: true,
        messages: {
          required: "Please enter challenge completed count",
          min: "Minimum count should be 1",
          max: "Maximum count can be 10000",
          digits: "Please enter only digits"
        }
      })
    });

    // Challenge User Segment Logins Count Validation
    $('#segment-value-login-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        min: 1,
        max: 10000,
        digits: true,
        messages: {
          required: "Please enter no of logins",
          min: "Minimum count should be 1",
          max: "Maximum count can be 10000",
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

    // // Challenge User Segment Rewards Validation
    // $('#segment-value-rewards-' + phaseCounter).each(function () {
    //   $(this).rules("add", {
    //     required: true,
    //     messages: {
    //       required: "Please select a reward"
    //     }
    //   })
    // });
    //
    // // Challenge User Segment Platform Validation
    // $('#segment-conditions-platforms-' + phaseCounter).each(function () {
    //   $(this).rules("add", {
    //     required: true,
    //     messages: {
    //       required: "Please select a platform"
    //     }
    //   })
    // });

    // Challenge User Segment Gender Validation
    $('#segment-value-gender-' + phaseCounter).each(function () {
      $(this).rules("add", {
        required: true,
        messages: {
          required: "Please select gender"
        }
      })
    });

    // // Challenge User Segment Challenge Validation
    // $('#segment-value-challenge-' + phaseCounter).each(function () {
    //   $(this).rules("add", {
    //     required: true,
    //     messages: {
    //       required: "Please select a challenge"
    //     }
    //   })
    // });
  }

  // Replace ID of Newly Added Fields of User Segment
  // function addSelect2(phaseCounter) {
  //   // Select2 for Reward Dropdown in User Segment Conditions
  //   $('#segment-value-rewards-' + phaseCounter).select2({
  //     dropdownAutoWidth: true,
  //     width: '100%'
  //   }).next().hide();
  //
  //   // Select2 for Challenge Dropdown in User Segment Conditions
  //   $('#segment-value-challenge-' + phaseCounter).select2({
  //     dropdownAutoWidth: true,
  //     width: '100%'
  //   }).next().hide();
  // }

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
    if (challengeType == 'collect' && (challengeParameters == 'profile' || challengeParameters == 'quiz' || challengeParameters == 'survey')) {
      $('.' + challengeType + '-' + challengeParameters + '-div .disabled-field').prop("disabled", true);
      $('.' + challengeType + '-' + challengeParameters + '-div .question-selector').trigger('change');

      // Quill Editor Initialization While Edit
      if ($(`.${challengeType}-${challengeParameters}-div .question-wysiwyg-editor`).length > 0) {
        $(`.${challengeType}-${challengeParameters}-div .question-wysiwyg-editor`).each(function (index) {
          if ($(this).hasClass('display-editor')) {
            $(this).show();
            $(`.${challengeType}-${challengeParameters}-div .question-box${$(this).data('editor-identifire')} .non-wysiwyg-field`).hide();
            new Quill(`.question-wysiwyg-editor${$(this).data('editor-identifire')}`, toolbar);
            $(`.question-wysiwyg-editor${$(this).data('editor-identifire')}`).css('display', 'block');
          }
        });
      }
      addOptionValidations();
      manageQuestionSequence();
      manageOptionSequence();
    }

    // Load Google Map if Challenge Type is Location
    if (challengeType == 'location') {
      initAutocomplete()
    }

    if (challengeType == 'share' && challengeParameters == 'facebook') {
      $('.share-facebook-div .social-title-txt').addClass('always-validate');
      $('.share-twitter-div .social-description-txt').removeClass('always-validate');
    } else if (challengeType == 'share' && challengeParameters == 'twitter') {
      $('.share-twitter-div .social-description-txt').addClass('always-validate');
      $('.share-facebook-div .social-description-txt').removeClass('always-validate');
    }
  }

  // Trigger Radius Calculation
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

  // Check for Facebook social connection
  $.validator.addMethod('facebookSocialFeedConnection', function (value) {
    var step = $('.step-top-padding.current').data('step-id');
    var challengeType = $('.challenge-type-list.active').data('challenge-parameters');

    if (step == '1' && value == 'engage' && challengeType == 'facebook') {
      var isConnected = $('.social-feed-checker').data('connect-facebook');

      return isConnected;
    }

    return true;
  }, 'You can not proceed further. Please add a Facebook account in your network');

  // Check for Instagram social connection
  $.validator.addMethod('instagramSocialFeedConnection', function (value) {
    var step = $('.step-top-padding.current').data('step-id');
    var challengeType = $('.challenge-type-list.active').data('challenge-parameters');

    if (step == '1' && value == 'engage' && challengeType == 'instagram') {
      var isConnected = $('.social-feed-checker').data('connect-instagram');

      return isConnected;
    }

    return true;
  }, 'You can not proceed further. Please add an Instagram account in your network');

  // Social Blog Title Validator
  $.validator.addMethod('socialTitle', function (value) {
    var step = $('.step-top-padding.current').data('step-id');

    // Validate Only Step 2 is Active
    if (step != '2') {
      return true;
    }

    // if ($('#challenge_parameters').val() == 'twitter') {
    //   return true;
    // }

    if ($('#challenge_parameters').val() == 'facebook') {
      socialTitle = $("#facebookBlockBody .social-title-txt").val();
    } else if ($('#challenge_parameters').val() == 'twitter') {
      socialTitle = $("#twitterBlockBody .social-title-txt").val();
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
      socialDescription = $("#twitterBlockBody .social-description-txt").val();
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
        required: true,
        facebookSocialFeedConnection: true,
        instagramSocialFeedConnection: true
      },
      'challenge[name]': {
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
        required: true,
        digits: true,
        min: 1,
        max: 100
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
      },
      'challenge[caption]': {
        required: true
      },
      'challenge[icon]': {
        required: true,
        extension: "jpg|jpeg|png|gif|svg"
      },
      'challenge[success_message]': {
        required: true
      },
      'challenge[failed_message]': {
        required: true
      },
      'challenge[correct_answer_count]': {
        required: true
      },
      'challenge[post_view_points]': {
        required: true,
        digits: true
      },
      'challenge[post_like_points]': {
        required: true,
        digits: true
      },
      'challenge[how_many_posts]': {
        required: true,
        digits: true
      }
    },
    messages: {
      'challenge[challenge_type]': {
        required: 'Please select challenge type'
      },
      'challenge[name]': {
        required: 'Please enter challenge name'
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
        required: 'Please select prize'
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
        required: 'Please enter duration in percentage',
        digits: 'Please enter duration in percentage',
        min: 'Duration should be minimum of 1',
        max: 'Duration should be maximum of 100'
      },
      'challenge[address]': {
        required: 'Please enter address'
      },
      'challenge[location_distance]': {
        required: 'Please select location radius'
      },
      'challenge[caption]': {
        required: 'Please enter challenge caption'
      },
      'challenge[icon]': {
        required: 'Please select challenge icon',
        extension: 'Please select challenge icon with valid extension'
      },
      'challenge[success_message]': {
        required: 'Please enter success message'
      },
      'challenge[failed_message]': {
        required: 'Please enter failure message'
      },
      'challenge[correct_answer_count]': {
        required: 'Please select correct answer count'
      },
      'challenge[post_view_points]': {
        required: 'Please enter points for a post view',
        digits: 'Please enter only digits'
      },
      'challenge[post_like_points]': {
        required: 'Please enter points for a post like',
        digits: 'Please enter only digits'
      },
      'challenge[how_many_posts]': {
        required: 'Please enter posts to fetch',
        digits: 'Please enter only digits'
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

  // Wizard Step 1 Challenge Type Selection Changes
  $('.challenge-type-list').on('click', function (e) {
    $('.add-challenge-form').trigger("reset");
    $('.challenge-type-list.active').removeClass('active');
    $(this).addClass('active');
    $('.challenge-name-span').html($(this).text());

    $('#challenge_challenge_type').val($(this).data('challenge-type'));
    $('#challenge_parameters').val($(this).data('challenge-parameters'));
    $('#challenge_category').val($(this).parents().eq(5).data('val'));

    var connectFacebook = $('#challenge_challenge_type').data('connect-facebook');
    stepTwoContent($(this).data('challenge-type'), $(this).data('challenge-parameters'))

    if (($(this).data('challenge-type') == 'engage')  && ($(this).data('challenge-parameters') == 'facebook' || $(this).data('challenge-parameters') == 'instagram')) {
      $('.step3-content-div').html('<div class="new_challenge_box text-center"><div className="row offset-sm-1 col-sm-10 offset-lg-2 col-lg-8"><h4>No Reward Config Needed for this Type of Challenge</h4></div></div>');
    } else {
      $('.step3-content-div').html('');
      $('.step3-content-div').append(step3ChallengeDiv);
    }
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

  $('body').on('change', '#file-input-twitter', function (e) {
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
        $("#facebookBlockBody :input").attr('disabled', false);
        $("#twitterBlockBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#facebookBlockBody .social-title-txt").val());
        $('#challenge_social_description').val($("#facebookBlockBody .social-description-txt").val());
      } else if (idx == 1) {
        // Twitter
        $('#challenge_parameters').val('twitter');
        $("#twitterBlockBody :input").attr('disabled', false);
        $("#facebookBlockBody :input").attr('disabled', true);
        $("#linkedinBlogBody :input").attr('disabled', true);

        $('#challenge_social_title').val($("#twitterBlockBody .social-title-txt").val());
        $('#challenge_social_description').val($("#twitterBlockBody .social-description-txt").val());
      } else if (idx == 2) {
        // LinkedIn
        $('#challenge_parameters').val('linked_in');
        $('#linkedinBlogBody :input').attr('disabled', false);
        $('#facebookBlockBody :input').attr('disabled', true);
        $('#twitterBlockBody :input').attr('disabled', true);

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
    // addSelect2(phaseCounter);
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
  $('body').on('focusout', '.social-title-txt', function (e) {
    if ($('#challenge_challenge_type').val() == 'share' && $('#challenge_parameters').val() == 'facebook') {
      $('.share-facebook-div #challenge_social_title').val($(this).val());
      $('.share-twitter-div #challenge_social_title').val('');
    } else if($('#challenge_challenge_type').val() == 'share' && $('#challenge_parameters').val() == 'twitter') {
      $('.share-twitter-div #challenge_social_title').val($(this).val());
      $('.share-facebook-div #challenge_social_title').val('');
    }
  });

  // Change Social Link Value
  $('body').on('focusout', '#challenge_link', function (e) {
    $('.social-link-label').html($(this).val());
  });

  // Change Social Description Value
  $('body').on('focusout', '.social-description-txt', function (e) {
    if ($('#challenge_challenge_type').val() == 'share' && $('#challenge_parameters').val() == 'facebook') {
      $('.share-facebook-div #challenge_social_description').val($(this).val());
      $('.share-twitter-div #challenge_social_description').val('');
    } else if($('#challenge_challenge_type').val() == 'share' && $('#challenge_parameters').val() == 'twitter') {
      $('.share-twitter-div #challenge_social_description').val($(this).val());
      $('.share-facebook-div #challenge_social_description').val('');
    }
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
    dateObj = new moment(date).utc().format('MM/DD/YYYY');
    return dateObj;
  }

  // Make First Letter of a string in Capitalize format
  function textCapitalize(textString) {
    if (textString) {
      return textString.charAt(0).toUpperCase() + textString.slice(1)
    } else {
      return ''
    }
  }

  // Make First Letter of a string in Capitalize format
  function rewardDisplay(details) {
    if (details.reward_type == 'points') {
      return details.points + 'pts';
    } else {
      var prizeName = details.reward_name;
      if (prizeName.length > 10) {
        prizeName = $.trim(prizeName).substring(0, 10).trim(prizeName) + "...";
      }
      return 'Prize<br>' + prizeName;
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
          html += '<img src="' + data.image['thumb']['url'] + '" style="margin-left:25px;" class="table_image_thumb_size" />'
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
          var cName = data.name
          if (cName.length > 23) {
            cName = $.trim(cName).substring(0, 23).trim(cName) + "...";
          }
          return '<span class="challenge-name" data-challenge-id="' + data.id + '" data-campaign-id="' + data.campaign_id + '">' + cName + '</span><br>' +
              textCapitalize(data.category)
        }
      },
      {
        class: 'product-name',
        title: 'Reward',
        data: null,
        searchable: false,
        render: function (data, type, row) {
          return rewardDisplay(data)
        }
      },
      {
        class: 'product-name',
        title: 'Completions',
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return data.completions
        }
      },
      {
        title: 'Clicks', data: null, searchable: false,
        render: function (data, type, row) {
          return '- - -'
        }
      },
      {
        title: 'Dates Active', data: null, searchable: false,
        render: function (data, type, row) {
          return formatDate(data.start) + ' -<br>' + formatDate(data.finish)
        }
      },
      {
        title: 'Date Created', data: null, searchable: false,
        render: function (data, type, row) {
          return formatDate(data.created_at)
        }
      },
      {
        class: 'product-action a',
        title: 'Actions', data: null, searchable: false, orderable: false,
        render: function (data, type, row) {
          actionText = data.is_approved ? ' Disable' : ' Approve'

          let action_html = "<div class='input-group' data-challenge-id ='" + data.id + "' data-campaign-id='" + data.campaign_id + "'>" +
              "<span class='dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='true'><i class='feather icon-more-horizontal'></i></span>" +
              "<div class='dropdown-menu more_action_bg' x-placement='bottom-end' style='position: absolute;z-index: 9999;'>"

          // // Stats Button
          // action_html = action_html + "<a class='dropdown-item' href='javascript:void(0);'><i class='feather icon-trending-up'></i> Stats</a>"

          // Edit Challenge Button
          action_html = action_html + "<a class='dropdown-item' href = '/admin/campaigns/" + data.campaign_id + "/challenges/" + data.id + "/edit'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Edit Challenge'>" +
              "<i class='feather icon-edit-2'></i> Edit</a>"

          // Download CSV Button
          action_html = action_html + "<a class='dropdown-item display-challenge-participants' href='javascript:void(0);'" +
              "data-toggle='tooltip' data-placement='top' data-original-title='Download CSV file of challenge participants'>" +
              "<i class='feather icon-download'></i> Download CSV</a>"

          // Duplicate a Challenge
          action_html = action_html + "<a class='dropdown-item clone-challenge' href='javascript:void(0);'><i class='feather icon-copy'></i> Duplicate</a>"

          // Approve/Disable a Challenge
          action_html = action_html + "<a class='dropdown-item toggle-challenge-status' href='javascript:void(0);'><i class='feather icon-check-square'></i> " + actionText + "</a>"

          action_html = action_html + "</div></div>"

          return action_html;
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
    aoColumnDefs: [
      {'bSortable': false, 'aTargets': [0]}
    ],
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

  // Quill Editor Integration for Challenge Articles
  if ($('.article-content-editor').length) {
    new Quill('.article-content-editor', toolbar);
  }

  // Add Quill Editor's Content of Challenge Articles to Actual Element
  $('.article-content-editor').focusout(function () {
    $('.article-content-txt-area').val($('.article-content-editor .ql-editor').html());
  });

  // Quill Editor Integration for Challenge Description
  if ($('.challenge-description-editor').length) {
    new Quill('.challenge-description-editor', toolbar);
  }

  // Add Quill Editor's Content of Challenge Description to Actual Element
  $('.challenge-description-editor').focusout(function () {
    $('.challenge-description-txt-area').val($('.challenge-description-editor .ql-editor').html());
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
    var filters = {
      status: [],
      challenge_type: [],
      platform_type: [],
      reward_type: [],
      tags: []
    }

    $("input[name='filters[status][]']:checked").each(function () {
      filters['status'].push($(this).data('val'));
    });

    $("input[name='filters[challenge_type][]']:checked").each(function () {
      filters['challenge_type'].push($(this).data('val'));
    });

    $("input[name='filters[platform_type][]']:checked").each(function () {
      filters['platform_type'].push($(this).data('val'));
    });

    $("input[name='filters[reward_type][]']:checked").each(function () {
      filters['reward_type'].push($(this).data('val'));
    });

    $('.challenge-tags-filter-chip').each(function () {
      filters['tags'].push($(this).data('tag-val'));
    });

    return filters;
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
        $('#challenge_image').removeClass('ignore'); // Remove Ignore Class to Validate New Uploaded Image
      }
      reader.readAsDataURL(this.files[0]);
    }
  });

  // Load Challenge Icon Image on Selection
  $('#challenge_icon').change(function () {
    if (this.files && this.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#challenge-icon-image-preview').attr('src', e.target.result);
        $('#challenge_icon').removeClass('ignore'); // Remove Ignore Class to Validate New Uploaded Image
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
    width: '100%'
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
  };

  // Question Selector Dropdown
  questionTypeSelect2();

  // Replace ID of Newly Added Fields of Challenge Question
  function replaceQuestionContainerFieldIds(stringDetails = 0, phaseCounter = 0, optionCounter = 0, optCounter = 0) {
    stringDetails = stringDetails.replace(/\___CLASS___/g, phaseCounter);
    stringDetails = stringDetails.replace(/\___NUM___/g, phaseCounter);
    stringDetails = stringDetails.replace(/\___ID___/g, phaseCounter);
    stringDetails = stringDetails.replace(/\___O_IDENTIFIRE_1___/g, optionCounter);
    stringDetails = stringDetails.replace(/\___O_IDENTIFIRE_2___/g, optCounter);
    stringDetails = stringDetails.replace(/\___O_ID___/g, optionCounter);

    return stringDetails;
  }

  // Manage Correct Answer Dropdown Options
  function changeCorrectCountOption(challengeType, challengeParameters) {
    if (challengeType == 'collect' && challengeParameters == 'quiz') {
      var dropDowns = $(`.${challengeType}-${challengeParameters}-div`).find('.question-selector');
      $('.correct_answer_count_dd').empty();
      var counter = 1;

      dropDowns.each(function (index) {
        if ($(this).val() != 'wysiwyg') {
          $('.correct_answer_count_dd').append($('<option/>', {
            value: counter,
            text: counter
          }));
          counter++;
        }
      });
    }
  }

  // Add New Question
  $('.add-challenge-question').on('click', function (e) {
    let questionTemplate = $(`#${$(this).data('type')}-question-template`).html();
    let phaseCounter = Math.floor(Math.random() * 90000) + 10000;
    let optionCounter = Math.floor(Math.random() * 90000) + 10000;
    let optCounter = Math.floor(Math.random() * 90000) + 10000;

    var challengeType = $('#challenge_challenge_type').val();
    var challengeParameters = $('#challenge_parameters').val();

    questionHtml = replaceQuestionContainerFieldIds(questionTemplate, phaseCounter, optionCounter, optCounter);

    $(`.${challengeType}-${challengeParameters}-div .questions-container`).append(questionHtml);
    changeCorrectCountOption(challengeType, challengeParameters);

    // Question Selector Dropdown
    questionTypeSelect2(phaseCounter);
    autoSelectText();
    addOptionValidations();
    manageQuestionSequence();
    enableSortingForOptions();
    manageOptionSequence();
  });

  // Manage Auto Selection of Text
  function autoSelectText() {
    $('.questions-container input').click(function () {
      $(this).select();
    });
  };

  // Show Hide Question Options Dynamically
  $('body').on('change', '.question-selector', function (e) {
    var selectedVal = $(this).val();
    var customId = $(this).data('custom-id');
    var challengeType = $('#challenge_challenge_type').val();
    var challengeParameters = $('#challenge_parameters').val();

    selectedVal = selectedVal.split("--");

    $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .options-container`).hide();
    $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .options-container input`).prop('disabled', true);

    $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .${selectedVal[0]}-container`).show();
    $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .${selectedVal[0]}-container .is-editable`).prop('disabled', false);

    if (selectedVal[0] == "wysiwyg") {
      $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .non-wysiwyg-field`).hide();
      $(`.question-wysiwyg-editor${customId}`).addClass('display-editor').show();

      // Quill Editor Integration for Campaign Rules
      if (!$(`.question-wysiwyg-editor${customId}`).hasClass('editor-initialize')) {
        $(`.question-wysiwyg-editor${customId}`).addClass('editor-initialize');

        if (!$(`.question-wysiwyg-editor${customId}`).hasClass('editor-added')) {
          new Quill(`.question-wysiwyg-editor${customId}`, toolbar);
        }
      }
    } else {
      $(`.question-wysiwyg-editor${customId}`).removeClass('display-editor').hide();
      $(`.${challengeType}-${challengeParameters}-div .question-box${customId} .non-wysiwyg-field`).show();
    }

    autoSelectText();
    addOptionValidations();
    changeCorrectCountOption(challengeType, challengeParameters);
    manageOptionSequence();
  });

  // Remove Question With Validation
  $('body').on('click', '.question_del_icon', function (e) {
    var challengeType = $('#challenge_challenge_type').val();
    var challengeParameters = $('#challenge_parameters').val();

    if ($(`.${challengeType}-${challengeParameters}-div .question_del_icon`).length > 1) {
      $(this).parent().parent().parent().parent().remove();
      changeCorrectCountOption(challengeType, challengeParameters);
      manageQuestionSequence();
    } else {
      swalNotify('Remove Question', 'You can not remove all questions, Atleast one question needed.');
    }
  });

  // Remove Question Option With Validation
  $('body').on('click', '.que_edit_cross', function (e) {
    var options = $(this).parent().parent().find('.que_edit').length

    if (options > 2) {
      $(this).parent().remove();
      manageOptionSequence();
    } else {
      swalNotify('Remove Option', 'You can not remove all options, Atleast one option needed.');
    }
  });

  // Remove Question Image Option With Validation
  $('body').on('click', '.image_cross_js', function (e) {
    var options = $(this).parents().eq(5).find('.que_edit').length

    if (options > 2) {
      $(this).parents().eq(4).remove();
      manageOptionSequence();
    } else {
      swalNotify('Remove Option', 'You can not remove all options, Atleast one option needed.');
    }
  });

  // Add New Option to a Question
  $('body').on('click', '.add-challenge-option', function (e) {
    var firstOption = $(this).parent().parent().parent().find('.que_edit').first()
    var cloneOption = firstOption.clone();

    // show the remove icon
    $(cloneOption.find('.icon-trash-2')).removeClass('hide');
    $(cloneOption.find('.image_cross_js')).removeClass('hide');

    // Remove Hidden Field for Option Id
    cloneOption.find('.hidden-option-field').remove();

    // Set New Value to Option
    var optionHtml = cloneOption.html();
    var qOption = cloneOption.find('.form-control-option');
    optionHtml = optionHtml.replace(qOption.val(), "New Option");

    var phaseCounter = Math.floor(Math.random() * 90000) + 10000;
    var optionCounter = Math.floor(Math.random() * 90000) + 10000;
    var optCounter = Math.floor(Math.random() * 90000) + 10000;
    optionHtml = replaceQuestionContainerFieldIds(optionHtml, phaseCounter, optionCounter, optCounter)

    // Set New Name to Option
    var optIdentifire = qOption.data('option-identifire');

    var oldIdent = `data-option-identifire="${optIdentifire}"`
    var newIdent = `data-option-identifire="${optionCounter}"`
    optionHtml = optionHtml.replace(oldIdent, newIdent);

    // Set New Option Identifire to Option
    var oldName = `[question_options_attributes][${optIdentifire}][details]`
    var newName = `[question_options_attributes][${optionCounter}][details]`
    optionHtml = optionHtml.replace(oldName, newName);

    // Set New Option Identifire to Answer
    var oldAnsName = `[question_options_attributes][${optIdentifire}][answer]`
    var newAnsName = `[question_options_attributes][${optionCounter}][answer]`
    optionHtml = optionHtml.replace(oldAnsName, newAnsName);

    // Set New Option Identifire to Sequence
    var oldSeqName = `[question_options_attributes][${optIdentifire}][sequence]`
    var newSeqName = `[question_options_attributes][${optionCounter}][sequence]`
    optionHtml = optionHtml.replace(oldSeqName, newSeqName);

    // Set New Option Identifire to Image Option
    var oldImgName = `[question_options_attributes][${optIdentifire}][image]`
    var newImgName = `[question_options_attributes][${optionCounter}][image]`
    optionHtml = optionHtml.replace(oldImgName, newImgName);

    // Set New Option Identifire to Image
    var oldImageForName = `for="file-upload${optIdentifire}"`
    var newImageForName = `for="file-upload${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageForName, newImageForName);

    var oldImageIdName = `id="file-upload${optIdentifire}"`
    var newImageIdName = `id="file-upload${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageIdName, newImageIdName);

    // Set New Option Identifire to Image
    var oldImageForName = `for="file-upload-${optIdentifire}"`
    var newImageForName = `for="file-upload-${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageForName, newImageForName);

    var oldImageIdName = `id="file-upload-${optIdentifire}"`
    var newImageIdName = `id="file-upload-${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageIdName, newImageIdName);

    var oldImageOptionErrorClassName = `class="image-option-error image-option-error-${optIdentifire}"`
    var newImageOptionErrorClassName = `class="image-option-error image-option-error-${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageOptionErrorClassName, newImageOptionErrorClassName);

    var oldImageOptionDataErrorClassName = `error="image-option-error-${optIdentifire}"`
    var newImageOptionDataErrorClassName = `error="image-option-error-${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageOptionDataErrorClassName, newImageOptionDataErrorClassName);

    var oldImageOptionDataErrorClassName = `error="image-option-error-${optIdentifire}"`
    var newImageOptionDataErrorClassName = `error="image-option-error-${optionCounter}"`
    optionHtml = optionHtml.replace(oldImageOptionDataErrorClassName, newImageOptionDataErrorClassName);

    // Remove Default Selected Answer Checkbox
    optionHtml = optionHtml.replace('checked="checked"', '');

    // optionHtml.replace(optIdentifire, optionCounter);
    // var lastThirty = optName.substr(optName.length - 30);

    // $('<div class="que_edit">' + optionHtml + '</div>').insertBefore($(this).parent().parent());
    var new_element = $(`<div class="${$(this).parent().parent().parent().find('.que_edit:nth-child(2)').attr('class')}">` + optionHtml + '</div>').insertBefore($(this).parent().parent());
    new_element.find('.social_img_show').attr('src', '');
    new_element.find('.social_img_show_bg').css("background-image", "url('#')");
    new_element.find(`.image-option-error-${optionCounter}`).html('');
    new_element.find('.image-uploader-control').addClass('always-validate');

    autoSelectText();
    addOptionValidations();
    manageOptionSequence();
  });

  // Auto Select Text While Edit Profile Question
  autoSelectText();

  // Check Uncheck Question Answer
  $('body').on('change', '.answer-field', function (e) {
    $(this).parent().parent().parent().find('input:checkbox').prop('checked', false);
    $(this).parent().parent().parent().find('input:checkbox').attr('checked', false);
    $(this).parent().parent().parent().find('input:checkbox').removeAttr('checked');
    $(this).prop('checked', true);
  });

  // Check Uncheck Image Question Answer
  $('body').on('change', '.image-answer-field', function (e) {
    $(this).parent().parent().parent().parent().find('input:checkbox').prop('checked', false);
    $(this).parent().parent().parent().parent().find('input:checkbox').attr('checked', false);
    $(this).parent().parent().parent().parent().find('input:checkbox').removeAttr('checked');
    $(this).prop('checked', true);
  });

  // Manage Sorted Question Sequence
  function manageQuestionSequence() {
    let challengeType = $('#challenge_challenge_type').val();
    let challengeParameters = $('#challenge_parameters').val();
    $(`.${challengeType}-${challengeParameters}-div .questions-container .question_box`).each(function (index) {

      $(this).find('.question-sequence-hidden').val(index + 1);
    });
  }

  // Sort Questions
  $('.questions-container').sortable({
    handle: 'i.drag_option',
    update: function (event, ui) {
      manageQuestionSequence();
    }
  });

  // Manage Sorted Options Sequence
  function manageOptionSequence() {
    let challengeType = $('#challenge_challenge_type').val();
    let challengeParameters = $('#challenge_parameters').val();

    $(`.${challengeType}-${challengeParameters}-div .questions-container .question_box`).each(function (index) {
      let qBox = $(this);
      let qType = qBox.find('.question-selector').val();
      let selectedQtype = qType.split('--');

      qBox.find('.options-container').each(function (index) {
        let container = $(this);
        if (container.hasClass(`${selectedQtype[0]}-container`)) {
          container.find('.que_edit').each(function (index) {
            let option = $(this);
            option.find('.question-option-sequence-hidden').val(index + 1);
          });
        }
      });
    });
  }

  // Enable Sorting on Question Options
  function enableSortingForOptions() {
    $('.options-container').sortable({
      group: 'no-drop',
      handle: 'i.drag_option',
      items: '.que_edit',
      update: function (event, ui) {
        manageOptionSequence();
      }
    });
  }

  // Sort Question Options
  enableSortingForOptions();

  // Show Image Preview after Image Selection
  $('body').on('change', '.image-uploader-control', function () {
    var _this = $(this);

    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        var elem = _this.parent().parent().parent().find('.social_img_show');
        elem.attr('src', e.target.result);
        // elem.css('visibility', 'visible');

        var elemBg = _this.parent().parent().parent().find('.social_img_show_bg');
        elemBg.css("background-image", "url(" + e.target.result + ")");

        // var social_img = _this.parent().parent().parent().find('.social_image');
        // social_img.css('z-index', -1);
      }

      reader.readAsDataURL(this.files[0]);
    }
  });
});
