class InstagramSocialFeedService
  def initialize(org_id, campaign_id, network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch Instagram feeds for specific network
  def process
    Rails.logger.info "============= PROCESS Instagram FEEDs START ==================="
    if @organization.present? && @campaign.present? && @network.present? && @network.auth_token.present?

      ## Check whether Instagram Social Feed Challenge is Active & Available
      active_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'instagram').first
      if active_challenge.present?
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
              feeds.each do |feed|

                { "id" => "17853547654959812",
                  "caption" =>
                    "Before Rails 6, We had to run the following commands to set up the #database:\n\n## To Create the Database\n$ rails db:create\n\n## To Run the Migrations\n$ rails db:migrate\n\n## To Pre-populate the Database with Default Data\n$ rails db:seed\n\nRails 6, introduced new rails #command to get rid of running all the above commands individually. $ rails db:prepare\n\nThis command performs the following operations:\n\n1️⃣ Creates the Database.\n2️⃣ Loads the Schema.\n3️⃣ Seeds the Database.\n\nThus, While setting up rails #application, This new command saves lot of time.\n\n#rubyonrails #backenddeveloper #softwaredevelopers #ruby #developerspace #programmerlife #quarantinelife #stayhome #stayhomechallenge #workfromhome #railsdeveloper #migration",
                  "media_type" => "IMAGE",
                  "media_url" =>
                    "https://scontent.cdninstagram.com/v/t51.2885-15/94016852_1839277592869960_1939820741885319504_n.jpg?_nc_cat=108&ccb=2&_nc_sid=8ae9d6&_nc_ohc=uvTJcNQ2ROsAX_YxASQ&_nc_ht=scontent.cdninstagram.com&oh=7058c75fc9d1c91678449190a2001d76&oe=600116BA",
                  "permalink" => "https://www.instagram.com/p/B_JmbEnHLK8/",
                  "timestamp" => "2020-04-19T05:02:59+0000",
                  "username" => "im.h.k" }

                page_feed = instagram_page.network_page_posts.find_or_initialize_by(network_id: @network.id, campaign_id: @campaign.id, post_id: feed['id'])
                page_feed.update_attributes({
                                              message: feed['caption'],
                                              post_type: feed['media_type'].downcase,
                                              url: feed['permalink']
                                            })

                if feed['media_type'].downcase == 'carousel_album'
                  ## Fetch Child Items of Feed
                else
                  attachment = page_feed.network_page_post_attachments.find_or_initialize_by(attachment_id: feed['id'])
                  attachment.update_attributes({
                                                media_src: feed['media_url'],
                                                media_type: feed['media_type'].downcase,
                                                category: feed['media_type'].downcase == 'image' ? 'photo' : 'video_inline',
                                                url: feed['permalink']
                                              })
                end

                ## insert post attachments
                if post_attachments_data_hash['subattachments'].present?
                  post_attachments = post_attachments_data_hash['subattachments']['data']
                  post_attachments.each do |post_attachment|
                    net_page_post_att = network_page_post.network_page_post_attachments.where(category: post_attachment['type'], url: post_attachment['url']).first
                    att_type_key = post_attachment['media'].keys[0]

                    if net_page_post_att.present?
                      net_page_post_att.height = post_attachment['media'][att_type_key]['height']
                      net_page_post_att.width = post_attachment['media'][att_type_key]['width']
                      net_page_post_att.media_src = post_attachment['media'][att_type_key]['src']
                      net_page_post_att.media_type = post_attachment['media'].keys[0]
                      net_page_post_att.target = post_attachment['target']
                      net_page_post_att.save
                    else
                      net_page_post_att = network_page_post.network_page_post_attachments.new(
                        height: post_attachment['media'][att_type_key]['height'],
                        width: post_attachment['media'][att_type_key]['width'],
                        media_src: post_attachment['media'][att_type_key]['src'],
                        media_type: post_attachment['media'].keys[0],
                        category: post_attachment['type'],
                        url: post_attachment['url'],
                        target: post_attachment['target']
                      )
                      net_page_post_att.save
                    end
                  end
                else
                  net_page_post_att = network_page_post.network_page_post_attachments.where(category: post_attachments_data_hash['type'], url: post_attachments_data_hash['url']).first
                  att_type_key = post_attachments_data_hash['media'].keys[0]
                  if net_page_post_att.present?
                    net_page_post_att.height = post_attachments_data_hash['media'][att_type_key]['height']
                    net_page_post_att.width = post_attachments_data_hash['media'][att_type_key]['width']
                    net_page_post_att.media_src = post_attachments_data_hash['media'][att_type_key]['src']
                    net_page_post_att.media_type = post_attachments_data_hash['media'].keys[0]
                    net_page_post_att.video_source = post_attachments_data_hash['media']['source']
                    net_page_post_att.target = post_attachments_data_hash['target']
                    net_page_post_att.save
                  else
                    net_page_post_att = network_page_post.network_page_post_attachments.new(
                      height: post_attachments_data_hash['media'][att_type_key]['height'],
                      width: post_attachments_data_hash['media'][att_type_key]['width'],
                      media_src: post_attachments_data_hash['media'][att_type_key]['src'],
                      media_type: post_attachments_data_hash['media'].keys[0],
                      video_source: post_attachments_data_hash['media']['source'],
                      category: post_attachments_data_hash['type'],
                      url: post_attachments_data_hash['url'],
                      target: post_attachments_data_hash['target']
                    )
                    net_page_post_att.save
                  end
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

# long_token = HTTParty.get("https://graph.instagram.com/18018863950119606/children?fields=#{c_fields}&access_token=#{@instagram_network.auth_token}")