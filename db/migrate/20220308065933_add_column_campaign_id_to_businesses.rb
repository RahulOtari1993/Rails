class AddColumnCampaignIdToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :campaign_id, :integer
  end
end
