class AddPlaceholderDetailsToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :placeholder, :string
    add_column :questions, :additional_details, :string
  end
end
