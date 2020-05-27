class AddTitleAndIconToChallegne < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :caption, :string
    add_column :challenges, :icon, :string
  end
end
