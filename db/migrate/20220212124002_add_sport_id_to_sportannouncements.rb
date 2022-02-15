class AddSportIdToSportannouncements < ActiveRecord::Migration[5.2]
  def change
    add_column :sportannouncements, :sport_id, :integer
    add_index :sportannouncements, :sport_id
  end
end
