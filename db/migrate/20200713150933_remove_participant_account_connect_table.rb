class RemoveParticipantAccountConnectTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :participant_account_connects
  end
end
