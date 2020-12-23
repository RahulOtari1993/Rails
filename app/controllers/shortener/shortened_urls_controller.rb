class Shortener::ShortenedUrlsController < ActionController::Metal
  include ActionController::StrongParameters
  include ActionController::Redirecting
  include ActionController::Instrumentation
  include Rails.application.routes.url_helpers
  include Shortener
  include Ahoy

  def show
    ahoy = ::Ahoy::Tracker.new(controller: nil)
    ahoy.track "Short URL Visit", request.path_parameters
    token = ::Shortener::ShortenedUrl.extract_token(params[:id])
    track = Shortener.ignore_robots.blank? || request.human?
    url   = ::Shortener::ShortenedUrl.fetch_with_token(token: token, additional_params: params, track: track)
    # redirect_to url[:url], status: :moved_permanently
  end

end
