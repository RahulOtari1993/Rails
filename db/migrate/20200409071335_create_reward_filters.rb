class CreateRewardFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_filters do |t|
      t.references :reward
      t.string :reward_condition
      t.string :reward_value
      t.string :reward_event

      t.timestamps null: false
      t.timestamps
    end
  end
end
