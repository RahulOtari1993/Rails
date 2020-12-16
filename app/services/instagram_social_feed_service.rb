class InstagramSocialFeedService
  def initialize(org_id, campaign_id, network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch Instagram feeds for specific network
  def process
    Rails.logger.info "============= PROCESS Instagram FEEDs START ==================="
    if false && @organization.present? && @campaign.present? && @network.present? && @network.auth_token.present?

      ## Check whether Instagram Social Feed Challenge is Active & Available
      active_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'instagram').first
      if false && active_challenge.present?
        ## fetch client auth token and instagram app secret
        if @campaign.present? && @campaign.white_branding
          @conf = CampaignConfig.where(campaign_id: @campaign.id).first
        else
          @conf = GlobalConfiguration.first
        end

        if @conf.present? && @conf.instagram_app_secret.present?
          auth_token = @network.auth_token
          app_secret = @conf.instagram_app_secret
          feed_fields = "id,caption,media_type,media_url,permalink,thumbnail_url,timestamp,username"
          media_fields = "id,media_type,media_url,thumbnail_url,timestamp,permalink"

          if app_secret.present? && auth_token.present?
            ## Fetch User Details
            user_details = HTTParty.get("https://graph.instagram.com/me?fields=id,username&access_token=#{auth_token}")
            unless user_details.has_key?('error')
              ## Create / Update Instagram Page Details
              instagram_page = @network.network_pages.find_or_initialize_by(page_id: user_details['id'])
              instagram_page.update_attributes(page_name: 'Instagram Page', campaign_id: @campaign.id)

              ## Fetch Feeds of Instagram Account
              feeds = HTTParty.get("https://graph.instagram.com/me/media?fields=#{feed_fields}&access_token=#{auth_token}")
              feeds['data'].each do |feed|
                page_feed = instagram_page.network_page_posts.find_or_initialize_by(network_id: @network.id, post_id: feed['id'])
                page_feed.update_attributes({
                                              message: feed['caption'],
                                              post_type: feed['media_type'].downcase,
                                              url: feed['permalink'],
                                              created_time: feed['timestamp']
                                            })
                if feed['media_type'].downcase == 'carousel_album'
                  ## Fetch Child Items of Feed
                  attachments = HTTParty.get("https://graph.instagram.com/#{feed['id']}/children?fields=#{media_fields}&access_token=#{auth_token}")
                  unless attachments.has_key?('error')
                    attachments['data'].each do |attachment|
                      attachment_obj = page_feed.network_page_post_attachments.find_or_initialize_by(attachment_id: attachment['id'])
                      attachment_obj.update_attributes({
                                                     media_src: attachment['media_url'],
                                                     media_type: attachment['media_type'].downcase,
                                                     category: attachment['media_type'].downcase == 'image' ? 'photo' : 'video_inline',
                                                     url: attachment['permalink']
                                                   })
                    end
                  end
                else
                  attachment = page_feed.network_page_post_attachments.find_or_initialize_by(attachment_id: feed['id'])
                  attachment.update_attributes({
                                                media_src: feed['media_url'],
                                                media_type: feed['media_type'].downcase,
                                                category: feed['media_type'].downcase == 'image' ? 'photo' : 'video_inline',
                                                url: feed['permalink']
                                              })
                end
              end
            end
          end
        end
      end
    end
    Rails.logger.info "============= PROCESS Instagram FEEDs END ==================="
  end
end
