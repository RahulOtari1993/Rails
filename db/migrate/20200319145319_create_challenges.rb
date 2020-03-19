class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.references :campaign, foreign_key: true
      t.text :name
      t.integer :platform_id
      t.datetime :start
      t.datetime :finish
      t.string :timezone
      t.integer :points
      t.string :parameters
      t.string :mechanism
      t.boolean :feature
      t.integer :creator_id
      t.integer :approver_id
      t.text :content
      t.text :link
      t.integer :clicks

      t.timestamps
    end
  end
end
