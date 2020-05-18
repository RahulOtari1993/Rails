class CreateProfileAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_attributes do |t|
      t.references :campaign, foreign_key: true
      t.string :attribute_name
      t.string :display_name
      t.boolean :is_enabled
      t.boolean :is_custom

      t.timestamps
    end
  end
end
