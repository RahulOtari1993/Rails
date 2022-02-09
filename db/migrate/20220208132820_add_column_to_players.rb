class AddColumnToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :email, :string
  end
end
