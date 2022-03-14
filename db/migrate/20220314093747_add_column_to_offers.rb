class AddColumnToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :start_date, :datetime
    add_column :offers, :end_date, :datetime
  end
end
