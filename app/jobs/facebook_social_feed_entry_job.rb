class FacebookSocialFeedEntryJob

  ## Fetch Facebook feeds for all campaigns
  def perform(arg)
    Rails.logger.info "Facebook Social Feed Entry Job is Started AT #{Time.current}"

    Campaign.all each do |campaign|
      networks = campaign.newtorks.where(platform: 0).current_active.sort
      unless networks.blank?
        networks.each do |network|
          Rails.logger.info "Fetch Facebook feeds for Campaign: #{campaign.id} -- #{network.username} -- #{network.email} -- Start"
          ## Fetch facebook feeds for specific network
          facebook_service = FacebookSocialFeedService.new(campaign.organization_id, campaign.id, network.id)
          facebook_service.process

          Rails.logger.info "Fetch Facebook feeds for Campaign: #{campaign.id} -- #{network.username} -- #{network.email} -- Start"
        end
      end
    end
    Rails.logger.info "Facebook Social Feed Entry Job is ENDED AT #{Time.current}"
  end
end
