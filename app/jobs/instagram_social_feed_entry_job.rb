class InstagramSocialFeedEntryJob < ActiveJob::Base

  ## Fetch Instagram feeds for all campaigns
  def perform(arg = nil)
    Rails.logger.info "******** Instagram Social Feed Entry Job -> Start ********"
    Campaign.active.each do |campaign|
      Rails.logger.info "******** Campaign: #{campaign.name} -> Start ********"
      networks = campaign.networks.where(platform: 'instagram').current_active.sort
      unless networks.blank?
        networks.each do |network|
          ## Fetch instagram feeds for specific network
          instagram_service = InstagramSocialFeedService.new(campaign.organization_id, campaign.id, network.id)
          instagram_service.process
        end
      end
      Rails.logger.info "******** Campaign: #{campaign.name} -> End ********"
    end
    Rails.logger.info "******** Instagram Social Feed Entry Job -> End ********"
  end
end
