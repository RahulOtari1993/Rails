class AddColumnsToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :notes, :text
    add_column :rewards, :msrp_value, :integer
    add_column :rewards, :bonus_points, :integer
  end
end
