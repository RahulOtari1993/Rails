class CreateParticipantActions < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_actions do |t|
      t.references :participant, foreign_key: true
      t.integer    :points
      t.integer    :action_type
      t.string     :title
      t.string     :details
      t.integer    :actionable_id
      t.string     :actionable_type

      t.timestamps
    end
  end
end
