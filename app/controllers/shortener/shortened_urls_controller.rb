class Shortener::ShortenedUrlsController < ApplicationController
	include ActionController::StrongParameters
	include ActionController::Redirecting
	include ActionController::Instrumentation
	include AbstractController::Rendering
	include ActionView::Rendering
	include ActionController::Rendering
	include Rails.application.routes.url_helpers
	include Shortener
	include Ahoy

	layout 'end_user'

	def show
		ahoy = ::Ahoy::Tracker.new(controller: nil)
		ahoy.track "Short URL Visit", request.path_parameters
		token = ::Shortener::ShortenedUrl.extract_token(params[:id])
		track = Shortener.ignore_robots.blank? || request.human?
		url = ::Shortener::ShortenedUrl.fetch_with_token(token: token, additional_params: params, track: track)
		begin
			if url[:url].include?('utm_source=') && url[:url].include?('utm_campaign=')
				uri = URI.parse(url[:url]).query
				campaign_id = uri.split('utm_campaign=').last.split('&').first
				challenge_id = uri.split('utm_source=').last.split('&').first

				@campaign = Campaign.find(campaign_id)
				@challenge = @campaign.challenges.find(challenge_id)
				@og = nil
				if @campaign && @challenge
					if @campaign.present? && @campaign.white_branding
						@conf = CampaignConfig.where(campaign_id: @campaign.id).first
					else
						@conf = GlobalConfiguration.first
					end

					@og = OpenGraphService.new
					@og.site_name = @campaign.name
					@og.title = !@challenge.social_title.blank? ? @challenge.social_title : @challenge.name
					@og.description = !@challenge.social_description.blank? ? @challenge.social_description : @challenge.description
					@og.image = !@challenge.social_image.blank? ? @challenge.social_image.url : @challenge.image.url
					@og.content_type = 'website'
					@og.fb_app_id = @conf.facebook_app_id
					@og.url = "#{request.protocol}#{request.host}#{request.path}"
				end
				@og

				render 'show'
			end
		rescue Exception => e
			# No campaign or challenge with ID for campaign
			render 'show'
		end
		# redirect_to url[:url], status: :moved_permanently
	end

end
