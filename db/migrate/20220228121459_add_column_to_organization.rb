class AddColumnToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :services, :text
    add_column :organizations, :address, :string
  end
end
