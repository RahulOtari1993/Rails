class RemoveColumnPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :player_id, :integer 
    remove_column :posts, :sport_id, :integer
  end
end
