class AddStatusToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :status, :integer, default: 0
    remove_column :participants, :is_active

    Participant.update_all(status: 1)
    Participant.where(connect_type: 3).update_all(connect_type: 2)
  end
end
