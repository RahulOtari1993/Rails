class AddSocialColumnsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :image, :string
    add_column :challenges, :social_title, :string
    add_column :challenges, :social_description, :string

    rename_column :challenges, :platform_id, :platform
  end
end
