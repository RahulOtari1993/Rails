class RefreshInstagramTokensService
	def initialize(campaign_id, network_id)
		@campaign = Campaign.where(id: campaign_id).first rescue nil
		@network = @campaign.networks.where(id: network_id).first rescue nil
	end

	## Fetch Instagram feeds for specific network
	def process
		Rails.logger.info "============= Refresh Instagram Tokens Service START ==================="

		if @campaign.present? && @network.present? && @network.auth_token.present?
			begin
				## Check whether Instagram Social Feed Challenge is Active & Available
				active_challenge = @campaign.challenges.current_active.where(challenge_type: 'engage', parameters: 'instagram').first
				if active_challenge.present? && active_challenge.how_many_posts.present?
					token_details = HTTParty.get("https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&access_token=#{@network.auth_token}")
					unless token_details.has_key?('error')
						@network.update({auth_token: token_details['access_token']}) if token_details.has_key?('access_token') && token_details['access_token'].present?
					end
				end
			rescue Exception => e
				Rails.logger.info "ERROR: Refresh Instagram Tokens Service --> Campaign: #{@campaign.name} -> Message: #{e.message}"
			end
		end

		Rails.logger.info "============= Refresh Instagram Tokens Service END ==================="
	end
end
