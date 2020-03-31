class Campaigns::DashboardController < ApplicationController
  # layout 'campaign'

  before_action :authenticate_user!

  def index

  end
end
