class CreateCampaignTemplateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_template_details do |t|
      t.references :campaign, foreign_key: true
      t.string :favicon_file
      t.string :footer_background_color
      t.string :footer_font_color
      t.float :footer_font_size

      t.string :header_background_image
      t.string :header_logo
      t.string :header_text
      t.string :header_font_color
      t.float :header_font_size

      t.timestamps
    end

    ## Update Existing Campaigns
    Campaign.all.each do |camp|
      CampaignTemplateDetail.create(campaign_id: camp.id)
    end

  end
end
