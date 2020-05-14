class AddFilterColumnsToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :filter_type, :integer, default: 0
    add_column :rewards, :filter_applied, :boolean, default: false
  end
end
