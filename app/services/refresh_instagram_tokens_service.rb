class RefreshInstagramTokensService
  def initialize(campaign_id, network_id)
    @campaign = Campaign.where(id: campaign_id).first rescue nil
    @network = @campaign.networks.where(id: network_id).first rescue nil
  end

  ## Fetch Instagram feeds for specific network
  def process
    Rails.logger.info "============= Refresh Instagram Tokens Service START ==================="
    if @campaign.present? && @network.present? && @network.auth_token.present?
      ## Check whether Instagram Social Feed Challenge is Active & Available
      active_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'instagram').first
      if active_challenge.present? && active_challenge.how_many_posts.present?
        ## Fetch Instagram App Secret
        if @campaign.present? && @campaign.white_branding
          conf = CampaignConfig.where(campaign_id: @campaign.id).first
        else
          conf = GlobalConfiguration.first
        end

        if conf.present? && conf.instagram_app_secret.present?
          ## TODO: Add Refresh Logic Gere
        end
      end
    end
    Rails.logger.info "============= Refresh Instagram Tokens Service END ==================="
  end
end
