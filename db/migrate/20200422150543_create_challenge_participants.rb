class CreateChallengeParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_participants do |t|
      t.references :challenge, foreign_key: true
      t.references :participant, foreign_key: true

      t.timestamps
    end
  end
end
