class AddSportIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :sport_id, :integer
    add_index :comments, :sport_id
  end
end
