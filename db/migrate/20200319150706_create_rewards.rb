class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.references :campaign, foreign_key: true
      t.string :name
      t.integer :limit
      t.integer :threshold
      t.text :description
      t.string :image_file_name
      t.decimal :image_file_size
      t.string :image_content_type
      t.string :selection
      t.datetime :start
      t.datetime :finish
      t.boolean :feature
      t.integer :points
      t.boolean :is_active
      t.text :redeption_details
      t.text :description_details
      t.text :terms_conditions
      t.integer :sweepstake_entry

      t.timestamps
    end
  end
end
