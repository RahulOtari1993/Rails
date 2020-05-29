class QuestionOptionColumnChanges < ActiveRecord::Migration[5.2]
  def change
    ## Drop Question Answer Table
    drop_table :answers

    add_column :question_options, :answer, :string, default: nil
  end
end
