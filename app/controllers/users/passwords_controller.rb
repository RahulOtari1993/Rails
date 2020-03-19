class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  # super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  def after_resetting_password_path_for(resource)
    ## Create Entry in Org Admin Table
    if resource.role == 'admin' && resource.organization_id.present?
      org_admin = OrganizationAdmin.where(organization_id: resource.organization_id, user_id: resource.id).first
      unless org_admin
        OrganizationAdmin.create(organization_id: resource.organization_id, user_id: resource.id)
        resource.update(is_active: true)
      end
    end

    super(resource)
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :organization_id, :reset_password_token, :role)
  end
end
