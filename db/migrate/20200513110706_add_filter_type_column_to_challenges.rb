class AddFilterTypeColumnToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :filter_type, :integer, default: 0
  end
end
