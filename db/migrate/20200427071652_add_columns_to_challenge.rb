class AddColumnsToChallenge < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :platform
    remove_column :challenges, :parameters
    rename_column :challenges, :mechanism, :challenge_type

    add_column :challenges, :social_image, :string
    add_column :challenges, :login_count, :integer
    add_column :challenges, :title, :string
    add_column :challenges, :points_click, :string
    add_column :challenges, :points_maximum, :string
    add_column :challenges, :duration, :float
    add_column :challenges, :parameters, :integer
    add_column :challenges, :category, :integer

    ## Location Columns
    add_column :challenges, :address, :string
    add_column :challenges, :longitude, :decimal
    add_column :challenges, :latitude, :decimal
    add_column :challenges, :location_distance, :float
  end
end
