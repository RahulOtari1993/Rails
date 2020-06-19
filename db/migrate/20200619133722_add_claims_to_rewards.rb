class AddClaimsToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :claims, :integer, default: 0
  end
end
