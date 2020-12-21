class RefreshInstagramTokensJob < ActiveJob::Base
  ## Refresh Instagram Tokens
  def perform(arg = nil)
    Rails.logger.info "******** Refresh Instagram Tokens -> Start ********"
    Campaign.active.each do |campaign|
      Rails.logger.info "******** Campaign: #{campaign.id} -> Start ********"

      networks = campaign.networks.where(platform: 'instagram').current_active.sort
      unless networks.blank?
        networks.each do |network|
          ## Refresh instagram tokens
          refresh_tokens_service = InstagramSocialFeedService.new(campaign.id, network.id)
          refresh_tokens_service.process
        end
      end

      Rails.logger.info "******** Campaign: #{campaign.id} -> End ********"
    end
    Rails.logger.info "******** Refresh Instagram Tokens -> End ********"
  end
end
