class AddColumnToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :photo_url, :text
    add_column :rewards, :thumb_url, :text
    add_column :rewards, :actual_image_url, :text
    add_column :rewards, :image_width, :integer
    add_column :rewards, :image_height, :integer
  end
end
