class AddSlugToAchievements < ActiveRecord::Migration[5.2]
  def change
    add_column :achievements, :slug, :string
    add_index :achievements, :slug, unique: true
  end
end
