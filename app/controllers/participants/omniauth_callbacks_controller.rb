# frozen_string_literal: true

class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  def facebook
    Rails.logger.info "************************ Call Back Called ************************"
    Rails.logger.info "************************ AUTH Params --> #{request.env["omniauth.auth"]} ************************"
    @participant = Participant.from_omniauth(request.env["omniauth.auth"])

    Rails.logger.info "************************ Participant --> #{@participant} ************************"

    if @participant.persisted?
      sign_in_and_redirect @participant, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  def google_oauth2
    @participant = Participant.from_omniauth(request.env["omniauth.auth"])
    if @participant.persisted?
      sign_in @participant, :event => :authentication #this will throw if @participant is not activated
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
    end
    redirect_to root_url
  end

  def setup
    request.env['omniauth.strategy'].options[:client_id] = "1933528990112651"
    request.env['omniauth.strategy'].options[:client_secret] = "ff21b05bb523c36c4509b9f7a24e46d7"
    render :text => "Setup complete.", :status => 404
  end

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
