class RemoveRewardFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :rewards, :image_file_name
    remove_column :rewards, :image_file_size
    remove_column :rewards, :image_content_type
  end
end
