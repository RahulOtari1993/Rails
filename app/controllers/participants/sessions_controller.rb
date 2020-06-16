# frozen_string_literal: true

class Participants::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  ## Configure End User Layout
  # layout 'end_user'


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   Rails.logger.info "======== IN @organization ---> #{@organization.inspect}"
  #   Rails.logger.info "======== IN EMAIL ---> #{params[:participant][:email].inspect}"
  #   org_participant = @organization.participants.find_by(:email => params[:participant][:email])
  #   Rails.logger.info "======== IN org_participant ---> #{org_participant.inspect}"
  #
  #   campaign_participant = @campaign.participants.where(:id => org_participant.id)
  #   Rails.logger.info "======== IN campaign_participant ---> #{campaign_participant.inspect}"
  #
  #   if org_participant.present? && campaign_participant.present?
  #
  #     self.resource = warden.authenticate!(auth_options)
  #     set_flash_message!(:notice, :signed_in)
  #     sign_in(resource_name, resource)
  #     yield resource if block_given?
  #     redirect_to root_path
  #
  #   elsif org_participant.present?
  #     @campaign.participants << org_participant
  #     redirect_to new_participant_session_path(resource)
  #   else
  #     redirect_to new_participant_session_path(resource) #new_participant_session_path(resource)
  #   end
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
end
