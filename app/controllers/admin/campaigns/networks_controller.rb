# require 'koala'

class Admin::Campaigns::NetworksController < Admin::Campaigns::BaseController
  before_action :authenticate_user!, except: [:connect_facebook]

  def index
    @config = @campaign.campaign_config
  end

  # call back url
  def connect_facebook
    Rails.logger.info "******** Call back from facebook started *********"
    @config = @campaign.campaign_config
    binding.pry
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

  def facebook_callback
  end

  private

end
