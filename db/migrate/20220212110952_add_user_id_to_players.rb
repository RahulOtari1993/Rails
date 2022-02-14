class AddUserIdToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :user_id, :integer
    add_index :players, :user_id
  end
end
