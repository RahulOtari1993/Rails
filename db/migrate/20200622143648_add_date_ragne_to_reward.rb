class AddDateRagneToReward < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :date_range, :boolean, default: false
  end
end
