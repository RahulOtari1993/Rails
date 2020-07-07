class EmailSettingService
  def initialize(campaign_id)
    @campaign = Campaign.find(campaign_id)
  end

  ## Create Email Settings for campaign
  def process
    details = generate_default_data
    details.each do |record|
      EmailSetting.create(record)
    end
  end

  ## Generate Default Hash for Email Settings
  def generate_default_data
    [
        {
            name: 'full',
            description: "Yes, I am interested in receiving emails related to #{@campaign.name.titleize} Rewards and other products and services I might find useful",
            campaign_id: @campaign.id
        },
        {
            name: 'semi-full',
            description: "Yes, I am only interested in receiving emails related to #{@campaign.name.titleize} Rewards",
            campaign_id: @campaign.id
        },
        {
            name: 'none',
            description: "No, I am not interested in receiving emails related to #{@campaign.name.titleize} Rewards or emails about any other products and services",
            campaign_id: @campaign.id
        }
    ]
  end
end
