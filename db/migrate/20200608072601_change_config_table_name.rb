class ChangeConfigTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :configurations, :global_configurations
  end
end
