class AddJobProfileAttributesForExistingCampaigns < ActiveRecord::Migration[5.2]
  def change
    new_attributes_details = [
                              { name: 'home_phone', display_name: 'Home Phone' },
                              { name: 'work_phone', display_name: 'Work Phone' },
                              { name: 'job_position', display_name: 'Current Job' },
                              { name: 'job_company_name', display_name: 'Company Name' },
                              { name: 'job_industry', display_name: 'Industry' }
                            ]

    Campaign.all.each do |campaign|
      new_attributes_details.each do |record|
        profile_attribute = campaign.profile_attributes.where(attribute_name: record[:name])
        unless profile_attribute.present?
          profile_attribute = ProfileAttribute.new({
            attribute_name: record[:name],
            display_name: record[:display_name],
            field_type: 'string',
            is_active: true,
            is_custom: false,
            campaign_id: campaign.id
          })
          profile_attribute.save
        end
      end
    end

  end
end
