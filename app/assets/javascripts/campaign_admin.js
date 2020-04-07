$(document).on('turbolinks:load', function() {
  // Fonts COnfig for Quill Editor
  var Font = Quill.import('formats/font');
  Font.whitelist = ['sofia', 'slabo', 'roboto', 'inconsolata', 'ubuntu'];
  Quill.register(Font, true);

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

  // Quill Editor Toolbar Config
  var toolbar = {
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
  };

  // Quill Editor Integration for Campaign Rules
  var fullEditor = new Quill('.campaign-rules-editor', {
    modules: toolbar,
    theme: 'snow'
  });

  // Quill Editor Integration for Campaign Privacy Policy
  var fullEditor = new Quill('.campaign-privacy-policy-editor', {
    modules: toolbar,
    theme: 'snow'
  });

  // Add Rules Details of Quill Editor to Campaign Rules
  $('.edit-campaign-form').on('submit', function () {
    $('.rules-txt-area').val($('.campaign-rules-editor .ql-editor').html());
    $('.privacy-txt-area').val($('.campaign-privacy-policy-editor .ql-editor').html());
  });
});
