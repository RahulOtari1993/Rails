class CreateRewardParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_participants do |t|
      t.references :reward, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
