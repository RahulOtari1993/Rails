class AddVisitIdToParticipantActions < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :ahoy_visit_id, :integer
  end
end
