class ChangeWhiteBrandingColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :white_branding, :boolean, default: false

    remove_column :configurations, :white_branding
  end
end
