class CreateRewardUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_users do |t|
      t.integer :reward_id
      t.integer :user_id
      t.integer :position
      t.timestamps
    end
  end
end
