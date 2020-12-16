class FacebookSocialFeedService
  def initialize(org_id, campaign_id, network_id)
    @organization = Organization.active.find(org_id) rescue nil
    @campaign = @organization.campaigns.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch facebook feeds for specific network
  def process
    if @organization.present? && @campaign.present? && @network.present?

      ## Check whether Facebook Social Feed Challenge is Active & Available
      facebook_media_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'facebook').first
      if facebook_media_challenge.present?
        ## fetch client auth token and facebook app secret
        auth_token = @network.auth_token
        facebook_app_secret = (@campaign.present? && @campaign.white_branding) ? CampaignConfig.where(campaign_id: @campaign.id).first.facebook_app_secret : GlobalConfiguration.first.facebook_app_secret

        ## initialize the connected facebook client
        client = Koala::Facebook::API.new(auth_token, facebook_app_secret)

        ## To fetch facebook pages and insert records
        page_records = client.get_connections('me', 'accounts')
        page_records.each do |page_record|

          Rails.logger.info "******** Fetch Facebook feeds for Page: #{page_record['name']} -- Start ********"

          network_page = @network.network_pages.where(page_id: page_record['id']).first
          if network_page.present?
            network_page.page_name = page_record['name']
            network_page.category = page_record['category']
            network_page.page_access_token = page_record['access_token']
            network_page.save
          else
            network_page = @campaign.network_pages.new(
              page_id: page_record['id'],
              page_name: page_record['name'],
              category: page_record['category'],
              page_access_token: page_record['access_token'],
              network_id: @network.id
            )
            network_page.save
          end

          ## To fetch facebook specific page posts and insert records
          page_posts = client.get_connection(network_page.page_id, 'posts')
          page_posts.each do |page_post|

            network_page_post = network_page.network_page_posts.where(network_id: @network.id, post_id: page_post['id']).first

            if network_page_post.present?
              network_page_post.message = page_post['message']
              network_page_post.created_time = page_post['created_time']
              network_page_post.save
            else
              network_page_post = network_page.network_page_posts.new(
                post_id: page_post['id'],
                message: page_post['message'],
                network_id: @network.id,
                network_page_id: network_page['id'],
                created_time: page_post['created_time']
              )
              network_page_post.save
            end

            ## To fetch facebook specific post attachments and insert records
            post_attachments_data_hash = client.get_connections(network_page_post.post_id, 'attachments')[0]

            ## update page post details
            network_page_post.title = post_attachments_data_hash['title']
            network_page_post.post_type = post_attachments_data_hash['type']
            network_page_post.url = post_attachments_data_hash['url']
            network_page_post.save

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

          Rails.logger.info "******** Fetch Facebook feeds for Page: #{page_record['name']} -- end ********"
        end
      end
    end
  end
end
