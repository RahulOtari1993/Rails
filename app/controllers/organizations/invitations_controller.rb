class Organizations::InvitationsController < Devise::RegistrationsController
  layout 'organization_admin'

  before_action :authenticate_user!
  before_action :configure_sign_up_params, only: [:create]

  def index
  end

  def new
    super
  end

  def create
    super
  end

  protected

  ## If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id, :is_active, :is_invited])
  end

  def after_inactive_sign_up_path_for(resource)
    organizations_users_path
  end
end
