class AddAgeToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :age, :integer
    add_column :participants, :login_count, :integer
  end
end
