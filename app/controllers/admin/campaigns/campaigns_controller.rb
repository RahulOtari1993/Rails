class Admin::Campaigns::CampaignsController < ApplicationController
  layout 'campaign_admin'

  before_action :authenticate_user!
  before_action :set_campaign
  before_action :is_admin

  def edit
  end

  private

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end

  ## Set Campaign
  def set_campaign
    @campaign = Campaign.where(id: params[:id]).first
  end
end
