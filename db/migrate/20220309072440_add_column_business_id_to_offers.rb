class AddColumnBusinessIdToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :business_id, :integer
  end
end
