class AddAffiliationAttributes < ActiveRecord::Migration[5.2]
  def change
    Campaign.all.each do |campaign|
      affiliation = campaign.profile_attributes.where(attribute_name: 'affiliation')

      unless affiliation.present?
        affiliation = ProfileAttribute.new({
                                               attribute_name: 'affiliation',
                                               display_name: 'Affiliation',
                                               field_type: 'check_box',
                                               is_active: true,
                                               is_custom: false,
                                               campaign_id: campaign.id
                                           })
        affiliation.save
      end
    end
  end
end
