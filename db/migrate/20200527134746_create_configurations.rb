class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations do |t|
      t.string :facebook_app_id
      t.string :facebook_app_secret
      t.string :google_client_id
      t.string :google_client_secret
      t.string :twitter_app_id
      t.string :twitter_app_secret

      t.timestamps
    end
  end
end
