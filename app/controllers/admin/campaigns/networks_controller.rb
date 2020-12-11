# require 'koala'

class Admin::Campaigns::NetworksController < Admin::Campaigns::BaseController
  before_action :authenticate_user!, except: [:connect_facebook]
  before_action :set_network, only: [:disconnect]

  def index
    @config = @campaign.campaign_config
    @facebook_network =  @campaign.networks.where(platform: 0).current_active.first
    @instagram_network = @campaign.networks.where(platform: 'instagram').current_active.first
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

  private

  def set_network
    @network = @campaign.networks.find(params[:id])
  end
end
