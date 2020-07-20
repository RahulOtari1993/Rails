class AddUseShortUrlFlagToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :use_short_url, :boolean, default: false, null: false
  end
end
