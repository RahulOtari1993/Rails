# frozen_string_literal: true

class Participants::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  after_action :after_login, :only => :create
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? } # was getting token error on email login
  ## Configure End User Layout
  # layout 'end_user'


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :organization_id])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   after_sign_in_path(resource)
  # end

  ## Pass Additional Param for Opening Popup of Onboarding Questions
  def after_sign_in_path_for(resource)
    root_path(:c => 1)
  end

  ## Create Login Entry for Participant
  def after_login
    log = ParticipantAction.new({participant_id: resource.id, points: 0, action_type: 'sign_in',
                                 title: 'Signed in', user_agent: request.user_agent, ip_address: request.remote_ip,
                                 campaign_id: resource.campaign_id})
    log.save
  end
end
