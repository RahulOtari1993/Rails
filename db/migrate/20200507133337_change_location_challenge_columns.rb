class ChangeLocationChallengeColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :challenges, :longitude
    remove_column :challenges, :latitude
    remove_column :challenges, :location_distance

    add_column :challenges, :longitude, :float
    add_column :challenges, :latitude, :float
    add_column :challenges, :location_distance, :integer
  end
end
