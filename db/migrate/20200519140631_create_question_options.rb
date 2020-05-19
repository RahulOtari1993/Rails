class CreateQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_options do |t|
      t.references :challenge, foreign_key: true
      t.references :question, foreign_key: true
      t.string :details

      t.timestamps
    end
  end
end
