class ParticipantColumnChangesForSubmission < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :user_id, :string
    add_column :submissions, :participant_id, :bigint, foreign_key: true
    add_index :submissions, :participant_id
  end
end
