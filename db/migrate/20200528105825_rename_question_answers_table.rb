class RenameQuestionAnswersTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :question_answers, :submitted_answers
  end
end
