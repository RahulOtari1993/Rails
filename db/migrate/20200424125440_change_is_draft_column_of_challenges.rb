class ChangeIsDraftColumnOfChallenges < ActiveRecord::Migration[5.2]
  def change
    rename_column :challenges, :is_draft, :is_approved
    change_column_default :challenges, :is_approved, false
  end
end
