class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :challenge, foreign_key: true
      t.integer :category
      t.string :title
      t.boolean :is_required
      t.integer :answer_type

      t.timestamps
    end
  end
end
