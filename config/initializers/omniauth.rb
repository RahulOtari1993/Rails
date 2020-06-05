OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, "220487462572080", "c7017afabe67ec0451ecba4d528e7098"
  provider :facebook, "19335289901126511", "ff21b05bb523c36c4509b9f7a24e46d71"
  provider :google_oauth2, "581864012746-j819vq950c9dd4i02br86viv5un4v2hi.apps.googleusercontent.com", "MdpEHhszerJVsHAwdtomhk4l"
end
