module CampaignHelper

  def campaign_route campaign
    domain = DomainList.where(campaign_id: campaign.id).first

    # if Rails.env == 'development'
    #   url = "http://#{domain.domain}.#{request.domain}:3000/campaigns/dashboard"
    # else
    #   url ="#{domain.domain}.#{request.domain}/campaigns/dashboard"
    # end

    if Rails.env == 'development'
      url = "http://#{domain.domain}.#{request.domain}:3000/campaigns"
    else
      url ="#{domain.domain}.#{request.domain}/campaigns"
    end

    url
  end

  def add_campaign
    if @is_admin
      "<div style='float:right;'>
          <a href=' #{new_admin_organizations_campaign_path }' class='btn-red-admin'>ADD CAMPAIGN</a>
       </div>".html_safe
    end
  end
end
