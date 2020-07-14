class DeleteSubmittedAnswerTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :submitted_answers
  end
end
