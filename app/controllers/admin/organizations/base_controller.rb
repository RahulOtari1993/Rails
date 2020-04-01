class Admin::Organizations::BaseController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!
  before_action :is_admin

  private

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end
end
