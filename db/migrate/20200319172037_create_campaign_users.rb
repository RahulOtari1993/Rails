class CreateCampaignUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_users do |t|
      t.references :user, foreign_key: true
      t.references :campaign, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
