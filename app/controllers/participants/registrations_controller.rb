# frozen_string_literal: true

class Participants::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  ## Configure End User Layout
  layout 'end_user'

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    user_agent = request.user_agent
    remote_ip = request.remote_ip

    ## Check if Participant Exists who Logged in Via Social Platform
    participant = Participant.where(organization_id: @organization.id, campaign_id: @campaign.id, email: params[:participant][:email]).first
    if participant.present? && (participant.google_uid.present? || participant.facebook_uid.present?)
      ## Update Existing Participant Details
      participant.first_name = params[:participant][:first_name]
      participant.last_name = params[:participant][:last_name]
      participant.password = params[:participant][:password]

      participant.skip_confirmation!
      participant.save(:validate => false)

      ## Mark Challenge as Completed & It's Relevant Entries
      participant.connect_challenge_completed(user_agent, remote_ip)

      sign_in_and_redirect participant, :event => :authentication
    else
      ## Regular Sign Up Using Devise
      super

      unless resource.errors.present?
        ## Mark Challenge as Completed & It's Relevant Entries
        resource.connect_challenge_completed(user_agent, remote_ip)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:first_name, :last_name, :email, :password,
                                             :password_confirmation, :organization_id, :is_active, :campaign_id,
                                             :connect_type])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   after_sign_in_path_for(resource) if is_navigational_format?
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   participant_dashboard_path
  # end
end
