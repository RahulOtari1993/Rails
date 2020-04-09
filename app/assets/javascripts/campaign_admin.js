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
});
