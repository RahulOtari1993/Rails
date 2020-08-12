class Admin::Organizations::CampaignsController < Admin::Organizations::BaseController
  before_action :set_campaign, only: :deactivate

  ## List all Organization Campaigns
  def index
    authorize @organization, :list_campaigns?
    @campaigns = @organization.campaigns.joins(:campaign_users).where(campaign_users: {user_id: current_user})
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        if @campaign.domain_type == 'own_domain'
          sub_domain = "#{@campaign.domain}"
        else
          sub_domain = "#{@organization.sub_domain}#{@campaign.domain}"
        end

        @domain_list = DomainList.new({domain: sub_domain, organization_id: @organization.id, campaign_id: @campaign.id})

        if @domain_list.save
          format.html { redirect_to admin_organizations_campaigns_path, notice: 'Program was successfully created.' }
          format.json { render :show, status: :created }
        else
          format.html { render :new }
          format.json { render json: @domain_list.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def deactivate
    if @campaign.present?
      @campaign.update(is_active: false)
      @campaign.campaign_deactivation
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :domain, :organization_id, :domain_type)
  end

  def set_campaign
    @campaign = Campaign.active.where(id: params[:id]).first
  end

  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end
end
