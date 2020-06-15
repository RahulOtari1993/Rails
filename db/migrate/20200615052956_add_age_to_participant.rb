class AddAgeToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :age, :integer
  end
end
