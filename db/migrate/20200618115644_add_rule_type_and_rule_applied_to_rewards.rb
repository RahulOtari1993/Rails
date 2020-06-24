class AddRuleTypeAndRuleAppliedToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :rule_type, :integer, default: 0
    add_column :rewards, :rule_applied, :boolean, default: false
  end
end
