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
  def create
    Rails.logger.info "======== IN @organization ---> #{org_participant.inspect}"
    Rails.logger.info "======== IN org_participant ---> #{org_participant.inspect}"
    Rails.logger.info "======== IN EMAIL ---> #{params[:participant][:email].inspect}"
    org_participant = @organization.participants.find_by(:email => params[:participant][:email])
    Rails.logger.info "======== IN org_participant ---> #{org_participant.inspect}"

    campaign_participant = @campaign.participants.where(:id => org_participant.id)
    Rails.logger.info "======== IN campaign_participant ---> #{campaign_participant.inspect}"

    if org_participant.present? && campaign_participant.present?

      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to participant_dashboard_path

    elsif org_participant.present?
      @campaign.participants << org_participant
      redirect_to new_participant_session_path(resource)
    else
      redirect_to new_participant_session_path(resource) #new_participant_session_path(resource)
    end
  end

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
  def after_sign_up_path_for(resource)
    after_sign_in_path(resource)
  end
  # def after_sign_in_path_for(resource)
  #   if resource.organization_admin?(@organization) #resource.is_invited?
  #     ## If User is Org Admin, Redirect him to Campaings Listing Page
  #     admin_organizations_campaigns_path
  #   else
  #     ## Check If User if Not a Campaign Participant
  #     campaign_user = resource.campaign_users @organization
  #     if campaign_user.count > 0

  #       if campaign_user.count == 1
  #         ## If User belongs to only one Campaign, Redirect to Campaign Dashboard Page
  #         admin_campaign_dashboard_path(campaign_user.first.campaign)
  #       else
  #         ## If User belongs to many Campaign, Redirect to Campaign List Page
  #         admin_organizations_campaigns_path
  #       end
  #     else
  #       root_url
  #     end
  #   end
  # end
end
