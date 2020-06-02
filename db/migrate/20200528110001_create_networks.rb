class CreateNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :networks do |t|
      t.references :campaign, foreign_key: true
      t.integer :platform
      t.string :auth_token
      t.string :username

      t.timestamps
    end
  end
end
