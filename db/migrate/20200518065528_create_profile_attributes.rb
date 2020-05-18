class CreateProfileAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_attributes do |t|
      t.references :campaign, foreign_key: true
      t.string :attribute_name
      t.string :display_name
      t.integer :field_type
      t.boolean :is_active, default: true
      t.boolean :is_custom, default: true

      t.timestamps
    end
  end
end
