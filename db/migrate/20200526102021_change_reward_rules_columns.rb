class ChangeRewardRulesColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :reward_rules, :type, :rule_type
    rename_column :reward_rules, :condition, :rule_condition
    rename_column :reward_rules, :value, :rule_value
  end
end
