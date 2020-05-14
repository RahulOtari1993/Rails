class DropOrganizationConfigs < ActiveRecord::Migration[5.2]
  def change
    drop_table :organization_configs
  end
end
