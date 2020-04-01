class Admin::Organizations::InvitationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :is_admin
  before_action :configure_sign_up_params, only: [:create]

  layout 'organization_admin'

  def index
  end

  def new
    if current_user.present?
      super
    else
      redirect_to new_user_session_path
    end
  end

  def create
    if current_user.present?
      super
    else
      redirect_to new_user_session_path
    end
  end

  protected

  ## If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id, :is_active, :is_invited])
  end

  def after_inactive_sign_up_path_for(resource)
    admin_organizations_users_path
  end

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end
end
