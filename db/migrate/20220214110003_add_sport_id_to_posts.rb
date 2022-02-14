class AddSportIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sport_id, :integer
    add_index :posts, :sport_id
  end
end
