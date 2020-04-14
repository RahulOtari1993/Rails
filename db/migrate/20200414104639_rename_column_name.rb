class RenameColumnName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :rewards, :redeption_details, :redemption_details
  end
end
