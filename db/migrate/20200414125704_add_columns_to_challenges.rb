class AddColumnsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :description, :text
    add_column :challenges, :reward_type, :integer
    add_column :challenges, :reward_id, :bigint
  end
end
