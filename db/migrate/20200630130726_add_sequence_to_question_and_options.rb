class AddSequenceToQuestionAndOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :sequence, :integer
    add_column :question_options, :sequence, :integer
  end
end
