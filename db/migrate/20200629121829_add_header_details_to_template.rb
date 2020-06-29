class AddHeaderDetailsToTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :campaign_template_details, :header_description_font_size, :float
    add_column :campaign_template_details, :header_description_font_color, :string
  end
end
