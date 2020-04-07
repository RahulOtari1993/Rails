class AddColumnsToCampaignSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :general_title, :string
    add_column :campaigns, :my_account_title, :string
  end
end
