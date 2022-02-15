class AddColumnPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sport, :string
  end
end
