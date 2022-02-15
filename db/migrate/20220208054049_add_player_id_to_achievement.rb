class AddPlayerIdToAchievement < ActiveRecord::Migration[5.2]
  def change
    add_column :achievements, :player_id, :integer
    add_index :achievements, :player_id
  end
end
