class AddHashtagIdToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :hashtag_id, :integer
    add_index :comments, :hashtag_id
  end
end
