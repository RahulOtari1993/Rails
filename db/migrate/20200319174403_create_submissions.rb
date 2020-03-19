class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.references :user, foreign_key: true
      t.references :campaign, foreign_key: true
      t.integer :submissible_id
      t.string :submissible_type

      t.timestamps
    end
  end
end
