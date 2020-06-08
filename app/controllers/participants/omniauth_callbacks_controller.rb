# frozen_string_literal: true

class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  def facebook
    Rails.logger.info "************************ Call Back Called ************************"
    Rails.logger.info "************************ AUTH auth --> #{request.env["omniauth.auth"]} ************************"

    Rails.logger.info "************************ AUTH Params --> #{request.env["omniauth.params"]} ************************"

    Rails.logger.info "************************ AUTH Params URL--> #{request.env["omniauth.params"]["url"]} ************************"

    if request.env['omniauth.params']['type'] == 'sign_up' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi')
      Rails.logger.info "************************ IN IF ************************"
      @participant = Participant.from_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

      Rails.logger.info "************************ Participant --> #{@participant.inspect} ************************"

      if @participant.new_record?
        Rails.logger.info "************************ NEW PARTICIPANT RECORD ************************"
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to root_url
      else
        Rails.logger.info "************************ EXISTING RECORD BEFORE SIGN IN ************************"
        sign_in(@participant)
        Rails.logger.info "************************ EXISTING RECORD AFTER SIGN IN #{current_participant} ************************"
        redirect_to welcome_path
        # sign_in_and_redirect @participant, :event => :authentication
        # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
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
    ## Generate random number
    # number =  rand(8)
    # Rails.logger.info "======================== Random Number #{number} #{params} ========================"

    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign_id: @campaign.id).first
      Rails.logger.info "======================== Campaign Configs #{conf.inspect} ========================"
    else
      conf = GlobalConfiguration.first
      Rails.logger.info "======================== Perk Configs #{conf.inspect} ========================"
    end

    # if ((number % 2) == 0)
    #   ## HK FB App
    #   client_id = "1933528990112651"
    #   client_secret = "ff21b05bb523c36c4509b9f7a24e46d7"
    # else
    #   ## Ranga FB App
    #   client_id = "1585668911602610"
    #   client_secret = "3ef4e739b9274bdd3e9242cb8b09054e"
    # end

    request.env['omniauth.strategy'].options[:client_id] = conf.facebook_app_id
    request.env['omniauth.strategy'].options[:client_secret] = conf.facebook_app_secret
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
