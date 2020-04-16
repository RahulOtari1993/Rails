# frozen_string_literal: true

class Participants::PasswordsController < Devise::PasswordsController
  respond_to :json, :html
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
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
    if resource.organization_id.present?
      org_admin = OrganizationAdmin.where(organization_id: resource.organization_id)
      # unless org_admin
      #   OrganizationAdmin.create(organization_id: resource.organization_id, user_id: resource.id)
      #   resource.update(is_active: true)
      # end
    end
    redirect_to redirect_to after_sign_in_path
    # super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    redirect_to root_path
  end

  def resource_params
    params.require(:participant).permit(:email, :password, :organization_id, :reset_password_token, :password_confirmation)
  end
end
