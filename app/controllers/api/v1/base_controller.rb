class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  ## Runtime Exception Handling
  rescue_from Exception, with: :exception_handling

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
end
