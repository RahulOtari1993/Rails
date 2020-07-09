class CreateParticipantAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_answers do |t|
      t.references :campaign, foreign_key: true
      t.references :challenge, foreign_key: true
      t.references :question, foreign_key: true
      t.text :answer
      t.references :question_option, foreign_key: true
      t.references :participant, foreign_key: true
      t.boolean :result, default: false
      t.timestamps
    end
  end
end
