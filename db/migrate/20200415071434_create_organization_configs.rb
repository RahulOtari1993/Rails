class CreateOrganizationConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_configs do |t|
      t.references :organization, foreign_key: true
      t.string :facebook_app_id
      t.string :facebook_app_secret
      t.string :google_client_id
      t.string :google_client_secret

      t.timestamps
    end
  end
end
