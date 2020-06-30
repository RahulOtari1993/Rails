class AddCamoaignIdToParticipantAction < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :campaign_id, :bigint

    add_index :participant_actions, :campaign_id
  end
end
