class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_participant!

  ## Custom Authentication Error Message
  def render_authenticate_error
    return_error 401, false, 'You need to sign in or sign up before continuing.', {}
  end
end
