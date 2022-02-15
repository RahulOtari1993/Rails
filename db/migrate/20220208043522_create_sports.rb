class CreateSports < ActiveRecord::Migration[5.2]
  def change
    create_table :sports do |t|
      t.string :sport_name
      t.bigint :total_player

      t.timestamps
    end
  end
end
