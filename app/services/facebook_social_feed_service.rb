class FacebookSocialFeedService
  def initialize(org_id, campaign_id,  network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.newtorks.where(id: network_id) rescue nil
  end

  ## Fetch facebook feeds for specific network
  def process
    if @organization.present? && @campaign.present? && @network.present?
      #
      # conf = GlobalConfiguration.first
      # auth_token = @network.auth_token
      # client = Koala::Facebook::API.new(auth_token, conf.facebook_app_secret)
      # client.get_connections('me', 'posts')
      # client.get_connections('me', 'posts', {
      #   limit: 5,
      #   fields: ['message', 'id', 'from', 'type', 'picture', 'link', 'created_time', 'updated_time']
      # })


    end
  end
end
