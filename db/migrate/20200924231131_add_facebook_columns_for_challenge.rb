class AddFacebookColumnsForChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :post_view_points, :integer
    add_column :challenges, :post_like_points, :integer
  end
end
