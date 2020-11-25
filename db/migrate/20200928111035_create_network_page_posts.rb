class CreateNetworkPagePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :network_page_posts do |t|

      t.references :network, foreign_key: true
      t.references :network_page, foreign_key: true
      t.text :post_id
      t.text :message
      t.datetime :created_time
      t.text :title
      t.integer :post_type
      t.text :url
      t.integer :total_likes

      t.timestamps
    end
  end
end
