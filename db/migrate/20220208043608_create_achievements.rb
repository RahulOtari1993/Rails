class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.string :award
      t.string :medal

      t.timestamps
    end
  end
end
