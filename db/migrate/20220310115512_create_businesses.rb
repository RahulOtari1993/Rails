class CreateBusinesses < ActiveRecord::Migration[5.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
