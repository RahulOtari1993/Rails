class AddColumnsForNetworks < ActiveRecord::Migration[5.2]
  def change
    add_column :networks, :organization_id, :integer
    add_column :networks, :uid, :string
    add_column :networks, :email, :string
    add_column :networks, :expires_at, :datetime
    add_column :networks, :avatar, :string
  end
end
