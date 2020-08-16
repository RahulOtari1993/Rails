class AddOrRemoveColumsForCampaignTemplateDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :campaign_template_details, :element_css_style, :text
  end
end
