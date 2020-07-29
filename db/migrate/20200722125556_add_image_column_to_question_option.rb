class AddImageColumnToQuestionOption < ActiveRecord::Migration[5.2]
  def change
    add_column :question_options, :image, :string, default: nil
  end
end
