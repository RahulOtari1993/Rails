class AddColumnOrganizationIdToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :organization_id, :integer
  end
end
