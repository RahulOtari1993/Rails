class DropTableChallengeParticipant < ActiveRecord::Migration[5.2]
  def change
    drop_table :challenge_participants
  end
end
