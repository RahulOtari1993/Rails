class AddWhiteBrandingToConfigurations < ActiveRecord::Migration[5.2]
  def change
    add_column :configurations, :white_branding, :boolean
  end
end
