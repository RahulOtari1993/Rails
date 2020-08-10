class Api::V1::CampaignController < Api::V1::BaseController
  skip_before_action :authenticate_participant!, :only => :content

  ## Fetch Campaign Content Based on Params
  def content
    case params[:type]
      when 'faq'
        content = @campaign.faq_content
      when 'rules'
        content = @campaign.rules
      when 'privacy'
        content = @campaign.privacy
      when 'terms'
        content = @campaign.terms
      when 'contact_us'
        content = @campaign.contact_us
      when 'general_content'
        content = @campaign.general_content
      else
        ''
    end

    render_success 200, true, 'Details fetched successfully.', content
  end
end
