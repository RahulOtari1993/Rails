class AddInstagramConfigColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaign_configs, :instagram_app_id, :string
    add_column :campaign_configs, :instagram_app_secret, :string

    add_column :global_configurations, :instagram_app_id, :string
    add_column :global_configurations, :instagram_app_secret, :string
  end
end
