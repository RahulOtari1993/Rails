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
      imageName = $("#facebookBlockBody input[name='challenge[image]']").val();
    } else if ($('#challenge_platform').val() == 'twitter') {
      imageName = $("#twitterBlogBody input[name='challenge[image]']").val();
    } else if ($('#challenge_platform').val() == 'linked_in') {
      imageName = $("#linkedinBlogBody input[name='challenge[image]']").val();
    } else {
      imageName = ''
    }

    return imageName;
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
      socialTitle = $("#facebookBlockBody input[name='challenge[social_title]']").val();
    } else if ($('#challenge_platform').val() == 'linked_in') {
      socialTitle = $("#linkedinBlogBody input[name='challenge[social_title]']").val();
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
      socialDescription = $("#facebookBlockBody input[name='challenge[social_description]']").val();
    } else if ($('#challenge_platform').val() == 'twitter') {
      socialDescription = $("#twitterBlogBody input[name='challenge[social_description]']").val();
    } else if ($('#challenge_platform').val() == 'linked_in') {
      socialDescription = $("#linkedinBlogBody input[name='challenge[social_description]']").val();
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
      'challenge[social_title]': {
        socialTitle: true
      },
      'challenge[social_description]': {
        socialDesctiption: true
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
        $("#facebookBlogBody :input").attr("disabled", false);
        $("#twitterBlogBody :input").attr("disabled", true);
        $("#linkedinBlogBody :input").attr("disabled", true);
      } else if (idx == 1) {
        // Twitter
        $('#challenge_platform').val('twitter');
        $("#twitterBlogBody :input").attr("disabled", false);
        $("#facebookBlogBody :input").attr("disabled", true);
        $("#linkedinBlogBody :input").attr("disabled", true);
      } else if (idx == 2) {
        // LinkedIn
        $('#challenge_platform').val('linked_in');
        $("#linkedinBlogBody :input").attr("disabled", false);
        $("#facebookBlogBody :input").attr("disabled", true);
        $("#twitterBlogBody :input").attr("disabled", true);
      }

      if (idx == $('.collapse.show').index('.collapse')) {
        // prevent collapse
        e.stopPropagation();
      }
    }
  });

  $('#challenge_description').keyup(function () {
    $('.user-comment-section').html($(this).val());
  });

  // Add User Segment of Challenges Module
  $('.add-challenge-user-segment').on('click', function (e) {
    let challengeUserSegmentsTemplate = $('#challenge-user-segments-template').html();
    $('.campaign-user-segments-container').append(challengeUserSegmentsTemplate);
  });

  // Remove User Segment of Challenges Module
  $('body').on('click', '.remove-challenge-segment', function (e) {
    $(this).parent().parent().remove();
  });

  // Challenge Event Change Event
  $('body').on('change', '.challenge-event-dd', function (e) {
    var tableRow = $(this).parent().parent();

    // Hide All the Segmet Condition & Value Fields
    tableRow.find('.segment-conditions-container select').hide();
    tableRow.find('.segment-values-container select').hide();
    tableRow.find('.segment-values-container input').hide();

    // Display Segment Condition Drop Downs
    tableRow.find('.segment-conditions-' + $(this).val()).show();

    // Display Segment Values Inputs / Drop Downs
    tableRow.find('.segment-value-' + $(this).val()).show();
  });

});
