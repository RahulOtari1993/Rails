class CreateNetworkPages < ActiveRecord::Migration[5.2]
  def change
    create_table :network_pages do |t|

      t.string :page_id
      t.string :page_name
      t.string :category
      t.text :page_access_token
      t.references :campaign, foreign_key: true
      # t.references :challenge, foreign_key: true
      t.references :network, foreign_key: true
      t.timestamps
    end
  end
end
