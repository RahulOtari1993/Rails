class FacebookSocialFeedService
  def initialize(org_id, campaign_id, network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch Facebook Feeds
  def process
    if @organization.present? && @campaign.present? && @network.present? && @network.auth_token.present?
      ## Check whether Facebook Social Feed Challenge is Active & Available
      facebook_media_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'facebook').first
      if facebook_media_challenge.present?
        ## Fetch client auth token and facebook app secret
        if @campaign.present? && @campaign.white_branding
          conf = CampaignConfig.where(campaign_id: @campaign.id).first
        else
          conf = GlobalConfiguration.first
        end

        if conf.present? && conf.facebook_app_secret.present?
          ## Initialize Facebook Client
          client = Koala::Facebook::API.new(@network.auth_token, conf.facebook_app_secret)

          ## To fetch facebook pages and insert records
          page_records = client.get_connections('me', 'accounts')
          page_records.each do |page_record|
            Rails.logger.info "******** Fetch Facebook feeds for Page: #{page_record['name']} -- Start ********"

            ## Find Existing Facebook Page or Create a New One
            network_page = @network.network_pages.find_or_initialize_by(page_id: page_record['id'])
            network_page.update_attributes({
                                             page_name: page_record['name'],
                                             category: page_record['category'],
                                             page_access_token: page_record['access_token'],
                                             network_id: @network.id,
                                             campaign_id: @campaign.id
                                           })


            ## Fetch and collect all posts based challenge posts number
            total_page_posts = []
            total_records = facebook_media_challenge.how_many_posts
            iterations = total_records / 20
            remaining_items = total_records % 20
            iterations = iterations + 1 if remaining_items > 0
            next_page_params = ''


            iterations.times do |counter|
              pagination = ((iterations - 1) == counter && remaining_items != 0) ? remaining_items : 20

              unless next_page_params.blank?
                page_posts = client.get_connection(network_page.page_id, 'posts', limit: pagination, after: next_page_params)
              else
                page_posts = client.get_connection(network_page.page_id, 'posts', limit: pagination)
              end

              next_page_params = page_posts.next_page_params.blank? ? '' : page_posts.next_page_params[1]['after']
              total_page_posts += page_posts unless page_posts.blank?

              ## break the loop no further facebook posts available
              break if (counter !=0 && next_page_params.blank?)
            end

            ## Fetch Posts from Specific Facebook Page
            total_page_posts.each do |page_post|
              ## Find Existing Page Post or Create a New One
              network_page_post = network_page.network_page_posts.find_or_initialize_by(network_id: @network.id, post_id: page_post['id'])
              network_page_post.update_attributes({
                                                    message: page_post['message'],
                                                    network_page_id: network_page.id,
                                                    created_time: page_post['created_time']
                                                  })

              ## Fetch Post Attachments && Update Page Post Details
              attachments_hash = client.get_connections(network_page_post.post_id, 'attachments')[0]

              if attachments_hash.present?
                network_page_post.update({
                                           title: attachments_hash['title'],
                                           post_type: attachments_hash['type'] == 'video_inline' ? 'video' : attachments_hash['type'],
                                           url: attachments_hash['url']
                                         })

                if attachments_hash['subattachments'].present?
                  post_attachments = attachments_hash['subattachments']['data']
                  post_attachments.each do |post_attachment|
                    ## Find Existing Network Page Post or Create a New One
                    att_type_key = post_attachment['media'].keys[0]
                    category = post_attachment['type'] == 'video_inline' ? 'video' : post_attachment['type']
                    post = network_page_post.network_page_post_attachments.find_or_initialize_by(category: category, url: post_attachment['url'])
                    post.update_attributes({
                                             height: post_attachment['media'][att_type_key]['height'],
                                             width: post_attachment['media'][att_type_key]['width'],
                                             target: post_attachment['target'],
                                             image_source: post_attachment['media'][att_type_key]['src'],
                                             video_source: attachments_hash['media']['source']
                                           })
                  end
                else
                  att_type_key = attachments_hash['media'].keys[0]
                  category = attachments_hash['type'] == 'video_inline' ? 'video' : attachments_hash['type']
                  post = network_page_post.network_page_post_attachments.find_or_initialize_by(category: category, url: attachments_hash['url'])
                  post.update_attributes({
                                           height: attachments_hash['media'][att_type_key]['height'],
                                           width: attachments_hash['media'][att_type_key]['width'],
                                           target: attachments_hash['target'],
                                           image_source: attachments_hash['media'][att_type_key]['src'],
                                           video_source: attachments_hash['media']['source']
                                         })
                end
              end

            end
            Rails.logger.info "******** Fetch Facebook feeds for Page: #{page_record['name']} -- end ********"
          end
        end
      end
    end
  end
end
