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
    user_agent = request.user_agent
    remote_ip = request.remote_ip
    type = request.env['omniauth.params']['type']

    Rails.logger.info "============= REQUEST: #{request} ==================="
    Rails.logger.info "============= TYPE: #{type} ==================="
    Rails.logger.info "============= PARAMS: #{params} ==================="

    if type == 'social_feed' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi') && request.env['omniauth.params'].has_key?('ui')
      Rails.logger.info "********************** Instagram Callback Initiated **********************"
      campaign_id = request.env['omniauth.params']['ci']
      @network = User.instagram_connect(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip, request.env['omniauth.params']['ui'])
      # if @network.new_record?
      #   redirect_to "/admin/campaigns/#{campaign_id.to_i}/networks", notice: 'Connecting Facebook account failed.'
      # else
      #   redirect_to "/admin/campaigns/#{campaign_id.to_i}/networks", notice: 'Facebook account connected successfully.'
      # end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_url
    end
  end

  private

  def set_network
    @network = @campaign.networks.find(params[:id])
  end
end
