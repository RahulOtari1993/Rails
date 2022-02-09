class AddPostIdToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :post_id, :integer
    add_index :tags, :post_id
  end
end
