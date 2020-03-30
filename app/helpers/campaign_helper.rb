module CampaignHelper

  def campaign_route campaign
    domain = DomainList.where(campaign_id: campaign.id).first

    if Rails.env == 'development'
      url = "#{domain.domain}.#{request.domain}:3000/campaigns/dashboard"
    else
      url ="#{domain.domain}.#{request.domain}/campaigns/dashboard"
    end

    url
  end
end
