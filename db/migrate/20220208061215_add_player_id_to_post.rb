class AddPlayerIdToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :player_id, :integer
    add_index :posts, :player_id
  end
end
