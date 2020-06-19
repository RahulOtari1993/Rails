class AddOrRemoveColoumnsFromRewardParticipants < ActiveRecord::Migration[5.2]
  def change
    remove_column :reward_participants, :user_id, :integer
    remove_column :reward_participants, :position, :integer
    add_column :reward_participants, :participant_id, :integer
  end
end
