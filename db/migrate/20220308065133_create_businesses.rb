class CreateBusinesses < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :logo
      t.datetime :working_hours

      t.timestamps
    end
  end
end
