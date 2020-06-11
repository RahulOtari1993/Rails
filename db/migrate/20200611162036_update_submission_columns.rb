class UpdateSubmissionColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :submissible_id
    remove_column :submissions, :submissible_type

    add_column :submissions, :challenge_id, :bigint, foreign_key: true
    add_index :submissions, :challenge_id
  end
end
