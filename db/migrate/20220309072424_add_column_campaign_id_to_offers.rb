class AddColumnCampaignIdToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :campaign_id, :integer
  end
end
