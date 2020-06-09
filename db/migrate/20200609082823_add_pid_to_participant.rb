class AddPidToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :p_id, :string

    ## Update Existing Participants
    Participant.all.each do |participant|
      p_id = Participant.get_participant_id
      participant.p_id = p_id
      participant.save
    end
  end
end
