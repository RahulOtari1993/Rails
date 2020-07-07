class AddEmailSettingsForExistingCampaigns < ActiveRecord::Migration[5.2]
  def change
    Campaign.all.each do |campaign|
      campaign.create_email_settings
    end
  end
end
