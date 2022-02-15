class AddPlayerIdToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :player_id, :integer
    add_index :tags, :player_id
  end
end
