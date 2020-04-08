class Admin::Campaigns::BaseController < ApplicationController
  layout 'campaign_admin'

  before_action :authenticate_user!
  before_action :set_details
  before_action :is_admin

  private

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end

  ## Set Campaign & Template
  def set_details
    @campaign = Campaign.where(id: params[:campaign_id]).first
    @template = @campaign.campaign_template_detail if @campaign.present?
  end
end
