class ChangeDurationDataTypeOfChallenge < ActiveRecord::Migration[5.2]
  def change
    change_column :challenges, :duration, :integer
  end
end
