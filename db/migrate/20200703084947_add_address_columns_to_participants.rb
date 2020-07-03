class AddAddressColumnsToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :country, :string
    add_column :participants, :home_phone, :string
    add_column :participants, :work_phone, :string
  end
end
