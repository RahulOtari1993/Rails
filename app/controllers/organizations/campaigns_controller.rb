class Organizations::CampaignsController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!

  ## List all Organization Campaigns
  def index
    authorize @organization, :list_campaigns?
    @organization_users = @organization.campaigns
  end
end
