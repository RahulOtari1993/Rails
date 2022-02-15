class CreateSportannouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :sportannouncements do |t|
      t.string :msg
      t.string :sport

      t.timestamps
    end
  end
end
