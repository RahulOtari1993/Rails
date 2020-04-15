class AddColumnsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :description, :text
    add_column :challenges, :reward_type, :integer
    add_column :challenges, :reward_id, :bigint
    add_column :challenges, :is_draft, :boolean, default: true
  end
end
