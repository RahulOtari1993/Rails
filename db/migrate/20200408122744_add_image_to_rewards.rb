class AddImageToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :image, :string
  end
end
