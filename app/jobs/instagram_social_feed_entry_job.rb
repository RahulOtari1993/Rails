class InstagramSocialFeedEntryJob < ActiveJob::Base

  ## Fetch Instagram feeds for all campaigns
  def perform(arg = nil)
    Campaign.active.each do |campaign|
      Rails.logger.info "******** Instagram social feed entry job for Campaign: #{campaign.name} -- Start ********"
      networks = campaign.networks.where(platform: 'instagram').current_active.sort
      unless networks.blank?
        networks.each do |network|
          Rails.logger.info "******** Fetch Instagram feeds for Campaign: #{campaign.id} -- #{network.username} -- Start ********"
          ## Fetch instagram feeds for specific network
          instagram_service = InstagramSocialFeedService.new(campaign.organization_id, campaign.id, network.id)
          instagram_service.process
          Rails.logger.info "******** Fetch Instagram feeds for Campaign: #{campaign.id} -- #{network.username} -- End ********"
        end
      end
      Rails.logger.info "******** Instagram social feed entry job for Campaign: #{campaign.name} -- End ********"
    end
  end
end
