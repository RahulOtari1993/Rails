class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :title
      t.string :description
      t.string :coupon
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
