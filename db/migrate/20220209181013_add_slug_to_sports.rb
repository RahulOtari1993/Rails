class AddSlugToSports < ActiveRecord::Migration[5.2]
  def change
    add_column :sports, :slug, :string
    add_index :sports, :slug, unique: true
  end
end
