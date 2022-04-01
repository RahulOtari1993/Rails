Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, Rails.application.credentials[:linkedin][:api_id], Rails.application.credentials[:linkedin][:api_key] , secure_image_url: true
end