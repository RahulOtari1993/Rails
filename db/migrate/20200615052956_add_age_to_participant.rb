class AddAgeToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :age, :integer, default: 0
    add_column :participants, :completed_challenges, :integer, default: 0
  end
end
