class CreateNetworkPagePostAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :network_page_post_attachments do |t|

      t.references :network_page_post, foreign_key: true
      t.integer :height
      t.integer :width
      t.text :media_src
      t.integer :media_type
      t.integer :category
      t.text :url
      t.text :video_source
      t.integer :likes
      t.json :target

      t.timestamps
    end
  end
end
