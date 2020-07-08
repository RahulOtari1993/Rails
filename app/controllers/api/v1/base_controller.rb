class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  ## Runtime Exception Handling
  rescue_from Exception, with: :exception_handling
  rescue_from Rack::Timeout::RequestTimeoutError, Rack::Timeout::RequestExpiryError,
              Rack::Timeout::RequestTimeoutException, :with => :handle_timeout

  before_action :authenticate_participant!

  ## Custom Authentication Error Message
  def render_authenticate_error
    return_error 401, false, 'You need to sign in or sign up before continuing.', {}
  end

  ## Runtime Exception Handling
  def exception_handling(e)
    Rails.logger.error "Exception Handling: #{e}"
    return_error 500, false, 'Oops. Something went wrong, please try again after some time.', {}
  end

  ## Handle Timeouts of API Calls
  def handle_timeout(e)
    Rails.logger.error "Handle timeout error: #{e}"
    return_error 408, false, 'Oops. Service Unavailable, please try again after some time.', {}
  end

  ## Set Page Number
  def page
    @page ||= params[:page] || 1
  end

  ## Set Per Page Records Length
  def per_page
    @per_page ||= params[:per_page] || 20
  end

  ## Set Total Records Count in Response Header
  def set_pagination_header(resource)
    headers['X-Total-Count'] = resource.total_count
  end
end
