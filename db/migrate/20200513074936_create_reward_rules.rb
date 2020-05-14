class CreateRewardRules < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_rules do |t|
      t.string :type
      t.references :reward, foreign_key: true
      t.string :condition
      t.string :value

      t.timestamps
    end
  end
end
