class AddColumnInPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :game_name, :string
  end
end
