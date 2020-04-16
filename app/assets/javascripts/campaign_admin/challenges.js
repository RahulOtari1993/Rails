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
      // 'hk_s4_2': {
      //   required: true
      // },
      // 'hk_s5_1': {
      //   required: true
      // }
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
      // 'hk_s4_2': {
      //   required: 'Please enter last name'
      // },
      // 'hk_s5_1': {
      //   required: 'Please enter email address'
      // }
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


  //
  // function readURL(input) {
  //   console.log("Input", input.find('#file-input-fb'));
  //
  //   if (input.files && input.files[0]) {
  //     var reader = new FileReader();
  //
  //     reader.onload = function (e) {
  //       console.log("IN", e.target.result)
  //       $('#facebook-img').attr('src', e.target.result);
  //     }
  //
  //     reader.readAsDataURL(input.files[0]);
  //   }
  // }
  //
  // $(".image-upload").change(function(){
  //   console.log("In Change");
  //   readURL($(this));
  // });


  $('body').on('change', '.image-upload', function (e) {
    console.log("HIi", $(this));
    console.log("HIi", $(this).data('file-id'));
    // console.log("In Change", $('.image-upload-fb').find('#file-input-fb'));
    //
    // console.log("In Change elem", $(this).find('#file-input-fb'));

    // var oFReader = new FileReader();
    // oFReader.readAsDataURL(document.getElementById("").files[0]);
    //
    // $('.challenge-type-card.active').removeClass('active');
    // $(this).addClass('active');
    //
    // $('#challenge_mechanism').val($(this).data('val'));
  })
});
