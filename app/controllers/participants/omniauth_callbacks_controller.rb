class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    Rails.logger.info "***************** USER AGENT --> #{request.user_agent} *****************"
    Rails.logger.info "***************** USER IP --> #{request.remote_ip} *****************"

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
    Rails.logger.info "***************** USER AGENT --> #{request.user_agent} *****************"
    Rails.logger.info "***************** USER IP --> #{request.remote_ip} *****************"

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

    request.env['omniauth.strategy'].options[:client_id] = conf.google_client_id
    request.env['omniauth.strategy'].options[:client_secret] = conf.google_client_secret
    render :json => {:success => "Configuration Changes Successfully"}.to_json, :status => 404
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
