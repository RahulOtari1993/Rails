class AddDefaultValueForDomainType < ActiveRecord::Migration[5.2]
  def change
    change_column :campaigns, :domain_type, :integer, :default => 1
  end
end
