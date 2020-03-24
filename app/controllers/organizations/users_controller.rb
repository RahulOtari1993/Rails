class Organizations::UsersController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!

  def index
  end
end
