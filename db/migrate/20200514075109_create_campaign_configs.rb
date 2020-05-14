class CreateCampaignConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_configs do |t|
      t.references :campaign, foreign_key: true
      t.string :facebook_app_id
      t.string :facebook_app_secret
      t.string :google_client_id
      t.string :google_client_secret
      t.string :twitter_app_id
      t.string :twitter_app_secret

      t.timestamps
    end

    ## Create Empty Campaign Config Entries for Existing Campaigns
    Campaign.all.each do |campaign|
      CampaignConfig.create(campaign_id: campaign.id)
    end
  end
end
