$(document).on('turbolinks:load', function() {
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

  // Quill Editor Integration for Campaigns
  var fullEditor = new Quill('.campaign-settings-editor', {
    bounds: '.campaign-settings-editor',
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
      ]
    },
    theme: 'snow'
  });

  $('.add-campaign-form').on('submit', function () {
    var hvalue = $('.ql-editor').html();
    $('.rules-txt-area').val(hvalue);
  });
});
