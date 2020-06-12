class AddCompletionsToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :completions, :integer, default: 0
  end
end
