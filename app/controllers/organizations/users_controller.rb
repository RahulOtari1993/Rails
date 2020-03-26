class Organizations::UsersController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!
  before_action :set_user, only: :toggle_active_status

  ## List all Organization Admin Users
  def index
    authorize @organization, :list_admins?
    @organization_users = @organization.admins
  end

  ## Active / De-active a Organization Admin User
  def toggle_active_status
    @user.toggle!(:is_active)
  end

  protected

  def set_user
    @user = User.where(id: params[:id]).first
  end
end
