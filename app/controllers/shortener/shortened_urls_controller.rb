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
		Rails.logger.info "=================================== SHOW ID: #{params[:refid].inspect} ==================================="
		token = ::Shortener::ShortenedUrl.extract_token(params[:refid])
		Rails.logger.info "=================================== SHOW TOKEN: #{token.inspect} ==================================="
		track = Shortener.ignore_robots.blank? || request.human?
		Rails.logger.info "=================================== SHOW track: #{track.inspect} ==================================="
		Rails.logger.info "=================================== additional_params track: #{params.inspect} ==================================="
		url = ::Shortener::ShortenedUrl.fetch_with_token(token: token, additional_params: params, track: track)
		Rails.logger.info "=================================== SHOW URL: #{url.inspect} ==================================="

		# begin
		# 	if url[:url].include?('utm_source=') && url[:url].include?('utm_campaign=')
		# 		uri = URI.parse(url[:url]).query
		# 		campaign_id = uri.split('utm_campaign=').last.split('&').first
		# 		challenge_id = uri.split('utm_source=').last.split('&').first
		#
		# 		@campaign = Campaign.find(campaign_id) rescue nil
		# 		@challenge = @campaign.challenges.find(challenge_id) rescue nil
		# 		@og = nil
		# 		@og = get_open_graph @challenge
		# 	end
		# rescue Exception => e
		# 	# No campaign or challenge with ID for campaign
		# end

		redirect_to url[:url], status: :moved_permanently
	end

end
