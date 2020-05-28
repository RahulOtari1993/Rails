class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :question, foreign_key: true
      t.references :question_option, foreign_key: true
      t.string     :value

      t.timestamps
    end
  end
end
