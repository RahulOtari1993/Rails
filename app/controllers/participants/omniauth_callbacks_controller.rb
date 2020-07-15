class Participants::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  ## Handle Facebook OAuth2 Callbacks
  def facebook
    user_agent = request.user_agent
    remote_ip = request.remote_ip
    type = request.env['omniauth.params']['type']

    if type == 'sign_up' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi')
      @participant = Participant.facebook_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip)

      if @participant[0].new_record?
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to root_url, notice: @participant[1]
      else
        sign_in_and_redirect @participant[0], :event => :authentication
      end
    elsif type == 'connect' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi') && request.env['omniauth.params'].has_key?('pi')
      @participant = Participant.facebook_connect(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip, request.env['omniauth.params']['pi'])

      if @participant.new_record?
        redirect_to root_url, notice: 'Connecting Facebook account failed.'
      else
        redirect_to root_url, notice: 'Facebook account connected successfully.'
      end
    elsif type == 'social_feed' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi') && request.env['omniauth.params'].has_key?('ui')
      Rails.logger.info "********************** Facebook Callback Initiated **********************"

      Rails.logger.info "********* Parameters: #{request.env['omniauth.params']}**********"
      Rails.logger.info "********* Response: #{request.env["omniauth.auth"]}**********"

      campaign_id = request.env['omniauth.params']['ci']
      @network = User.facebook_connect(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip, request.env['omniauth.params']['ui'])
      if @network.new_record?
        redirect_to "/admin/campaigns/#{campaign_id.to_i}/networks", notice: 'Connecting Facebook account failed.'
      else
        redirect_to "/admin/campaigns/#{campaign_id.to_i}/networks", notice: 'Facebook account connected successfully.'
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  ## Handle Google OAuth2 Callbacks
  def google_oauth2
    user_agent = request.user_agent
    remote_ip = request.remote_ip

    if request.env['omniauth.params']['type'] == 'sign_up' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi')
      @participant = Participant.google_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip)

      if @participant[0].new_record?
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to root_url, notice: @participant[1]
      else
        sign_in_and_redirect @participant[0], :event => :authentication
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  ## Handle Twitter OAuth2 Callbacks
  def twitter
    user_agent = request.user_agent
    remote_ip = request.remote_ip
    type = request.env['omniauth.params']['type']

    Rails.logger.info "============== type --> #{type} =============="
    if type == 'connect' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi') && request.env['omniauth.params'].has_key?('pi')
      @participant = Participant.twitter_connect(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip, request.env['omniauth.params']['pi'])

      Rails.logger.info "============== @participant --> #{@participant} =============="
      if @participant.new_record?
        redirect_to root_url, notice: 'Connecting Twitter account failed.'
      else
        redirect_to root_url, notice: 'Twitter account connected successfully.'
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  ## Setup OAuth Details for Facebook
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

  def callback_url
    "#{request.protocol}#{request.host}/participants/auth/facebook/callback"
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

  ## Setup OAuth Details for Twitter
  def twitter_oauth2_setup
    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    Rails.logger.info "================ twitter_oauth2_setup ================"

    request.env['omniauth.strategy'].options[:consumer_key]  = conf.twitter_app_id
    request.env['omniauth.strategy'].options[:consumer_secret] = conf.twitter_app_secret
    render :json => {:success => "Configuration Changes Successfully"}.to_json, :status => 404
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
