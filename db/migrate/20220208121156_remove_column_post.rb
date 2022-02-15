class RemoveColumnPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :tags, :string
  end
end
