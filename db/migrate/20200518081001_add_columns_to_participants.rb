class AddColumnsToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :utm_source, :string
    add_column :participants, :utm_medium, :string
    add_column :participants, :utm_term, :string
    add_column :participants, :utm_content, :string
    add_column :participants, :utm_name, :string

    add_column :participants, :birth_date, :date
    add_column :participants, :gender, :string
    add_column :participants, :phone, :string
    add_column :participants, :city, :string
    add_column :participants, :state, :string
    add_column :participants, :postal, :string

    add_column :participants, :address_1, :string
    add_column :participants, :address_2, :string
    add_column :participants, :bio, :text
  end
end
