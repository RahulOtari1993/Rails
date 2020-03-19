class Users::PasswordsController < Devise::PasswordsController
  # append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  # def create
  #   binding.pry
  #
  #
  #
  #   # self.resource = resource_class.send_reset_password_instructions(resource_params)
  #   #
  #   # unless successfully_sent?(resource)
  #   #   Devise::Mailer.reset_password_instructions(resource).deliver
  #   # end
  #   #
  #   # respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
  #
  #   # self.resource = resource_class.send_reset_password_instructions(resource_params)
  #   # yield resource if block_given?
  #   #
  #   # if successfully_sent?(resource)
  #   #   respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
  #   # else
  #   #   respond_with(resource)
  #   # end
  #
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

  # Check if a reset_password_token is provided in the request
  # def assert_reset_token_passed
  #   if params[:reset_password_token].blank?
  #
  #     binding.pry
  #
  #     set_flash_message(:alert, :no_token)
  #     redirect_to new_session_path(resource_name)
  #   end
  # end

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
  #   binding.pry
  #   super(resource_name)
  # end
  #
  # def resource_params
  #   # attributes = [:name, :location]
  #   # attributes.push(:secrets) if current_user.admin?
  #   #
  #   # params.require(:organization).permit(attributes)
  #
  #   params
  #                           .require(:user)
  #                           .permit(:email, :password, :password_confirmation, :organization_id, :reset_password_token, :role)
  # end
end
