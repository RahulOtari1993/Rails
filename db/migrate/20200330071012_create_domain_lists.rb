class CreateDomainLists < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_lists do |t|
      t.string :domain
      t.references :organization, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end

    add_index :domain_lists, [:campaign_id, :organization_id], unique: true
    add_index :domain_lists, :domain, unique: true
  end
end
