class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :player_name
      t.string :player_city
      t.string :player_state
      t.string :player_country
      t.string :phone
      t.string :gender

      t.timestamps
    end
  end
end
