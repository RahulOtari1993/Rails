class AddSuccessAndFailureMessageToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :success_message, :string
    add_column :challenges, :failed_message, :string
    add_column :challenges, :correct_answer_count, :integer
  end
end
