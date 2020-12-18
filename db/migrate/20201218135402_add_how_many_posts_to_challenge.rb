class AddHowManyPostsToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :how_many_posts, :integer
  end
end
