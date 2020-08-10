class Api::V1::CampaignConfigsController < Api::V1::BaseController
  skip_before_action :authenticate_participant!, :only => :index

  ## Fetch Campaign Configs Based on White Branding
  def index
    if @campaign.present? && @campaign.white_branding
      conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      conf = GlobalConfiguration.first
    end

    render_success 200, true, 'Program configs fetched successfully.', conf.as_json
  end
end
