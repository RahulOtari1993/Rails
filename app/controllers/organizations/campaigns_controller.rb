class Organizations::CampaignsController < ApplicationController
  layout 'organization_admin'

  before_action :authenticate_user!

  ## List all Organization Campaigns
  def index
    authorize @organization, :list_campaigns?
    @organization_users = @organization.campaigns
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to organizations_campaigns_path, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :domain, :organization_id)
  end
end
