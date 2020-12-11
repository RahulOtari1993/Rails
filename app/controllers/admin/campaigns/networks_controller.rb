# require 'koala'

class Admin::Campaigns::NetworksController < Admin::Campaigns::BaseController
  before_action :authenticate_user!, except: [:connect_facebook, :instagram_callback]
  before_action :set_network, only: [:disconnect]

  def index
    @config = @campaign.campaign_config
    @facebook_network =  @campaign.networks.where(platform: 0).current_active.first
    @instagram_network = @campaign.networks.where(platform: 'instagram').current_active.first

    if @campaign.present? && @campaign.white_branding
      @conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      @conf = GlobalConfiguration.first
    end
  end

  ## Disconnect the facebook for campaign
  def disconnect
    if @network.update(auth_token: nil, expires_at: nil)
      flash[:notice] = "You've been disconnected to #{@network.platform.titleize} Successfully."
    else
      flash[:notice] = "Something went wrong, Please try again later."
    end
    redirect_to admin_campaign_networks_path(@campaign)
  end

  # call back url
  def connect_facebook
    Rails.logger.info "******** Call back from facebook started *********"
    @config = @campaign.campaign_config
    # binding.pry
    # @oauth = Koala::Facebook::OAuth.new(@config.facebook_app_id, @config.facebook_app_secret, "http://osu.perksocial.local:3000/admin/campaigns/1/networks")
    # @oauth.get_app_access_token

    
    # Rails.application.config.middleware.use OmniAuth::Builder do
    #   provider :facebook, @config.facebook_app_id, @config.facebook_app_secret, callback_path: auth_facebook_callback_admin_campaign_networks_path(@campaign, campaign_id: @campaign.id)
    # end

    # @network = @campaign.networks.new(platform: "facebook")
    # Rails.logger.debug "******** #{request.params} *********"
    # Rails.logger.debug "******** #{request} *********"

    # flash[:notice] = "You are connected to Facebook Success."
    Rails.logger.info "******** redirected to networks index page *********"
    redirect_to admin_campaign_networks_path(@campaign)
  end

  def instagram_callback
    Rails.logger.info "********************** Instagram Callback Initiated **********************"
    user_agent = request.user_agent
    remote_ip = request.remote_ip


    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    Rails.logger.info "*********** Configs: #{conf.inspect} *************"
    Rails.logger.info "*********** Fetch AUth Token From Here Onwards *************"

    response = HTTParty.post("https://api.instagram.com/oauth/access_token", body: {
      client_id: conf.instagram_app_id,
      client_secret: conf.instagram_app_secret,
      grant_type: 'authorization_code',
      code: params['code'],
      redirect_uri: instagram_auth_callback_url
    })

    Rails.logger.info "*********** TOKEN Response: #{response.inspect} *************"

    if response.has_key?('access_token') && response.has_key?('user_id')
      long_token = HTTParty.get("https://api.instagram.com/oauth/access_token?
        client_secret=#{conf.instagram_app_secret}&
        grant_type=ig_exchange_token&
        access_token=#{response['access_token']}", format: :json
      )

      Rails.logger.info "*********** LONG TOKEN: #{long_token.inspect} *************"

      redirect_to admin_campaign_networks_path
    else
      flash[:notice] = response.has_key?('error_message') ? response['error_message'] : 'Instagram account configuration failed.'
      redirect_to admin_campaign_networks_path
    end
  end

  private

  def set_network
    @network = @campaign.networks.find(params[:id])
  end
end
