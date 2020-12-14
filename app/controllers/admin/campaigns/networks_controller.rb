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

    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    organization = @campaign.organization

    Rails.logger.info "*********** Configs: #{conf.inspect} *************"
    Rails.logger.info "*********** Fetch AUth Token From Here Onwards *************"

    response = HTTParty.post("https://api.instagram.com/oauth/access_token", body: {
      client_id: conf.instagram_app_id,
      client_secret: conf.instagram_app_secret,
      grant_type: 'authorization_code',
      code: params['code'],
      redirect_uri: instagram_auth_callback_url
    })

    Rails.logger.info "*********** TOKEN Response: #{response} *************"

    if response.has_key?('access_token') && response.has_key?('user_id')
      url = "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=#{conf.instagram_app_secret}&access_token=#{response['access_token']}"
      Rails.logger.info "*********** FETCH TOKEN URL: #{url} *************"

      token_response = `curl -X GET '#{url}'`
      token_response = JSON.parse(token_response)

      Rails.logger.info "*********** Long Token Details: #{token_response.inspect} *************"
      Rails.logger.info "*********** access_token Details: #{token_response['access_token'].inspect} *************"
      Rails.logger.info "*********** token_type Details: #{token_response['token_type'].inspect} *************"
      Rails.logger.info "*********** expires_in Details: #{token_response['expires_in'].inspect} *************"
      Rails.logger.info "*********** All Details: #{token_response.has_key?('access_token') && token_response.has_key?('token_type') && token_response.has_key?('expires_in')} *************"

      if token_response.has_key?('access_token') && token_response.has_key?('token_type') && token_response.has_key?('expires_in')
        ## Save the token response and user info details
        network = @campaign.networks.where(organization_id: organization.id, platform: 'instagram').first_or_initialize

        ## Update existing network or create a new Network
        network.auth_token = token_response['access_token']
        network.username = ''
        network.expires_at = Time.now + (token_response['access_token'] / 3600 / 24).days
        network.remote_avatar_url = ''
        if network.save
          flash[:notice] = 'Instagram account configuration successful.'
          redirect_to admin_campaign_networks_path(@campaign)
        else
          Rails.logger.info "*********** Error 333 *************"
          flash[:notice] = 'Instagram account configuration failed.'
          redirect_to admin_campaign_networks_path(@campaign)
        end
      else
        Rails.logger.info "*********** Error 222 *************"
        flash[:notice] = (response.has_key?('error') && response['error'].has_key?('message')) ? response['error']['message'] : 'Instagram account configuration failed.'
        redirect_to admin_campaign_networks_path(@campaign)
      end

      # long_token = HTTParty.post("https://graph.instagram.com/access_token", body: {
      #   client_id: conf.instagram_app_id,
      #   client_secret: conf.instagram_app_secret,
      #   grant_type: 'ig_exchange_token',
      #   access_token: response['access_token']
      # })
      #
      # { client_secret: '67c4da5924dae9253b4f10fdef1e8eda', grant_type: 'ig_exchange_token', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ' }
      #
      # ## Purl Curl Request
      # uri = URI.parse("https://api.instagram.com/oauth/access_token?grant_type=ig_exchange_token&client_secret=67c4da5924dae9253b4f10fdef1e8eda&access_token=IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ")
      # response = Net::HTTP.get_response(uri)
      #
      # ##
      # HTTParty.post("https://api.instagram.com/oauth/access_token", body: { client_id: '426018228762844', client_secret: '67c4da5924dae9253b4f10fdef1e8eda', grant_type: 'ig_exchange_token', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ' })
      # long_token = HTTParty.get("https://api.instagram.com/oauth/access_token?grant_type=ig_exchange_token&client_secret=#{conf.instagram_app_secret}&access_token=#{response['access_token']}", :headers => {"Content-Type" => "application/json"})
      #
      # long_token = HTTParty.get("https://api.instagram.com/oauth/access_token?grant_type=ig_exchange_token&client_secret=67c4da5924dae9253b4f10fdef1e8eda&access_token=IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ", :headers => {"Content-Type" => "application/json"}, format: :json)
      #
      # long_token = HTTParty.get("https://api.instagram.com/oauth/access_token", query: { grant_type: 'ig_exchange_token', client_secret: '67c4da5924dae9253b4f10fdef1e8eda', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ'}, :headers => {"Content-Type" => "application/json"})
      #
      # long_token = HTTParty.get("https://api.instagram.com/oauth/access_token", query: { grant_type: 'ig_exchange_token', client_secret: '67c4da5924dae9253b4f10fdef1e8eda', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ'})
      #
      #
      # ## Faraday Gem
      # resp = Faraday.get("https://api.instagram.com/oauth/access_token", {client_secret: '67c4da5924dae9253b4f10fdef1e8eda', grant_type: 'ig_exchange_token', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ'}, {'Accept' => 'text/html', 'Content-Type' => 'text/html'})
      #
      # resp = Faraday.get("https://api.instagram.com/oauth/access_token") do |req|
      #   req.headers['Content-Type'] = 'application/json'
      #   req.body = { client_secret: '67c4da5924dae9253b4f10fdef1e8eda', grant_type: 'ig_exchange_token', access_token: 'IGQVJXQ2lJU0NPNEV6Vktkbk5EYzhyLWdmSU9iQjRQU1VHNGduamV2VEFVd1dVWXdiUDdMekVxanA5YUExdHAxRllCMDI5VVR0ZA3RMVTl5QnNUYmczb3ViazJqdnowc1REUjRDSUhrc1RzRXdCZAUJyTkZApVnptb1JlejdJ' }.to_json
      # end
    else
      Rails.logger.info "*********** Error 111 *************"
      flash[:notice] = response.has_key?('error_message') ? response['error_message'] : 'Instagram account configuration failed.'
      redirect_to admin_campaign_networks_path(@campaign)
    end
  end

  private

  def set_network
    @network = @campaign.networks.find(params[:id])
  end

  def fetch_long_lived_token

  end
end
