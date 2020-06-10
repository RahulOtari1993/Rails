class AddHeaderDescriptionToCampaignTemplateDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :campaign_template_details, :header_description, :text
  end
end
