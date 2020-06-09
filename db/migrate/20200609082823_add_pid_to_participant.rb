class AddPidToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :p_id, :string
  end
end
