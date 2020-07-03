class CreateEmailSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :email_settings do |t|
      t.string :name
      t.string :description
      t.references :campaign, foreign_key: true
      t.timestamps
    end
  end
end
