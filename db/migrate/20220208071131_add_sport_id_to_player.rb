class AddSportIdToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :sport_id, :integer
    add_index :players, :sport_id
  end
end
