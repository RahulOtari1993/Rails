class CreateQuestionAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :question_answers do |t|
      t.references :challenge, foreign_key: true
      t.references :question, foreign_key: true
      t.references :participant, foreign_key: true
      t.references :question_option, foreign_key: true
      t.string :answer

      t.timestamps
    end
  end
end
