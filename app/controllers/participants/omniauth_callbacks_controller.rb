# frozen_string_literal: true

class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  def facebook
    if request.env['omniauth.params']['type'] == 'sign_up' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi')
      @participant = Participant.facebook_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

      if @participant.new_record?
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to root_url
      else
        sign_in_and_redirect @participant, :event => :authentication
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  def google_oauth2
    Rails.logger.info "************************* AUTH Details --> #{request.env["omniauth.auth"]} *************************"
    Rails.logger.info "************************* CONF Params --> #{request.env["omniauth.params"]} *************************"

    if request.env['omniauth.params']['type'] == 'sign_up' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi')
      @participant = Participant.google_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

      if @participant.new_record?
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to root_url
      else
        sign_in_and_redirect @participant, :event => :authentication
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end

    # @participant = Participant.from_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])
    # if @participant.persisted?
    #   sign_in @participant, :event => :authentication #this will throw if @participant is not activated
    #   set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    # else
    #   session["devise.google_data"] = request.env["omniauth.auth"]
    # end
    # redirect_to root_url
  end

  def setup
    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    request.env['omniauth.strategy'].options[:client_id] = conf.facebook_app_id
    request.env['omniauth.strategy'].options[:client_secret] = conf.facebook_app_secret
    render :json => {:success => "Configuration Changes Successfully"}.to_json, :status => 404
  end

  def google_oauth2_setup
    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    Rails.logger.info "************************* CONF Details --> #{conf.inspect} *************************"
    request.env['omniauth.strategy'].options[:client_id] = conf.google_client_id
    request.env['omniauth.strategy'].options[:client_secret] = conf.google_client_secret
    render :json => {:success => "Configuration Changes Successfully"}.to_json, :status => 404
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
