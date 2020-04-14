$(document).ready(function () {
  //reward selection dropdown onchange 
  $('#reward_selection').on('change', function () {
    if ($(this).val() == 'redeem' || $(this).val() == 'instant' || $(this).val() == 'selection') {
      $('.threshold').show();
    } else if ($(this).val() == 'manual' || $(this).val() == 'threshold') {
      $('.threshold').hide();
    } else if ($(this).val() == 'sweepstake') {
      $('.threshold').hide();
      $('.sweepstake').show();
    } else {
    }
  })
  //hide row in reward new and delete/hide row/reward_filter in edit page
  $('body').on('click', '.hide_row', function(e){
      e.preventDefault();  
      if($(this).attr('reward_filter_id') != undefined){ 
        $.ajax({
          type: 'POST',
          data: { authenticity_token: $('[name="csrf-token"]')[0].content},
          url: "/admin/delete_reward_filter/" + $(this).attr('reward_filter_id'),
          success: function(data, res){
            $(this).closest('tr').hide();
          }
        });
      }else{
        $(this).closest('tr').hide();
      }
    })
  // Add segment
  $('#add_segment').on('click', function (e) {
    e.preventDefault();
    var size = null
    var element = null
    size = $('#filter_conditions >tbody >tr').length + 1
    element = $('#filter_condition_1').clone();
    element.attr('id', 'filter_condition_' + size);
    $('.segment_table tbody').append(element);
    element.show();
  })
  //Submit form onclick skipping all input fields which are disabled
  $('.reward_form').on('click', function () {
    $('.segment_table').find('.filter_hidden').attr("disabled", true);
    var selects = $('.segment_table').find('select');
    var inputs = $('.segment_table').find('input');
    var rows = $('.segment_table').find('tr')
    for (var i = 0; i < selects.length; i++) {
      if (selects[i].style.display == 'none') {
        selects[i].disabled = true;
      }
    }
    for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].style.display == 'none') {
        inputs[i].disabled = true;
      }
    }
    for (var i = 0; i < rows.length; i++) {
      if ($('tr').style.display == 'none') {
        $formInputs = $(this).find('input')
        $formSelects = $(this).find('select')
        $formInputs.prop("disabled", true);
        $formSelects.prop("disabled", true)
      }
    }
    $('form').submit();
  })
})
//Segment filter onchage dropdown hide/show
$('body').on('change', ".reward_event", function () {
  var val = $(this).val();
  var $currentRow = $(this).closest('tr');
  if (val == 'Tags') {
    // myFunction('age_reward_condition', 'gender_reward_condition', "three");
    $currentRow.find('.tags_reward_condition').removeClass('filter_hidden');
    $currentRow.find('.tags_reward_condition').show();
    $currentRow.find('.age_reward_condition').hide();
    $currentRow.find('.reward_value').show();
    $currentRow.find('.gender_reward_condition').hide();
    $currentRow.find('.gender_value').addClass('filter_hidden');
    $currentRow.find('.all_challenges_value ').hide();
    $currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.social_reward_value').hide();
  } else if (val == 'Gender') {
    $currentRow.find('.gender_reward_condition').removeClass('filter_hidden');
    $currentRow.find('.gender_reward_condition').show();
    $currentRow.find('.gender_value').show();
    $currentRow.find('.gender_value').removeClass('filter_hidden');
    $currentRow.find('.age_reward_condition').hide();
    $currentRow.find('.tags_reward_condition').hide();
    $currentRow.find('.reward_value').hide();
    $currentRow.find('.all_challenges_value ').hide();
    $currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.social_reward_value').hide();
    $currentRow.find('.reward_value').hide();
  } else if (val == 'Points') {
    $currentRow.find('.age_reward_condition').removeClass('.filter_hidden');
    $currentRow.find('.age_reward_condition').show();
    $currentRow.find('.reward_value').show();
    $currentRow.find('.gender_value').hide();
    $currentRow.find('.tags_reward_condition').hide();
    $currentRow.find('.gender_reward_condition').hide();
    $$currentRow.find('.all_challenges_value ').hide();
    $$currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.social_reward_value').hide();
  } else if (val == 'Rewards') {
    $currentRow.find('.all_rewards_value').removeClass('filter_hidden');
    $currentRow.find('.all_rewards_value').show();
    $currentRow.find('.reward_value').hide();
    $currentRow.find('.tags_reward_condition').hide();
    $currentRow.find('.age_reward_condition').hide();
    $currentRow.find('.gender_reward_condition').hide();
    $currentRow.find('.social_reward_value').hide();
    $currentRow.find('.all_challenges_value ').hide();
  } else if (val == 'Platforms') {
    $currentRow.find('.social_reward_value').removeClass('filter_hidden');
    $currentRow.find('.social_reward_value').show();
    $currentRow.find('.tags_reward_condition').show();
    $currentRow.find('.tags_reward_condition').removeClass('filter_hidden');
    $currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.gender_reward_condition').hide();
    $currentRow.find('.gender_value').hide();
    $currentRow.find('.age_reward_condition').hide();
    $currentRow.find('.reward_value').hide();
    $$currentRow.find('.all_challenges_value ').hide();
  } else if (val == "Challenges") {
    $currentRow.find('.all_challenges_value ').removeClass('filter_hidden');
    $currentRow.find('.all_challenges_value').show();
    $currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.gender_reward_value').hide();
    $currentRow.find('.age_reward_condition').hide();
    $currentRow.find('.reward_value').hide();
    $currentRow.find('.social_reward_value').hide();
  } else {
    $currentRow.find('.age_reward_condition').show();
    $currentRow.find('.age_reward_condition').removeClass('filter_hidden')
    $currentRow.find('.all_challenges_value ').hide();
    $currentRow.find('.gender_reward_condition').hide();
    $currentRow.find('.social_reward_value').hide();
    $currentRow.find('.reward_value').show();
    $currentRow.find('.all_rewards_value').hide();
    $currentRow.find('.tags_reward_condition').hide();
  }
})

//creating global function to use for dropdown
// function hide() {
//   for (var i = 0; i < arguments.length; i++){
//     $('.' + arguments[i]).hide();
//   }    
// }

