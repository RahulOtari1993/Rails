class InstagramSocialFeedService
  def initialize(org_id, campaign_id,  network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch Instagram feeds for specific network
  def process
    Rails.logger.info "============= PROCESS Instagram FEEDs ==================="
  end
end
