class AddReferredParticipantIdToParticipantActions < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :referred_participant_id, :integer
  end
end
