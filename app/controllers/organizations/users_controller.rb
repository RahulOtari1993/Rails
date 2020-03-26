class Organizations::UsersController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!

  def index
    @organization_users = @organization.admins
  end
end
