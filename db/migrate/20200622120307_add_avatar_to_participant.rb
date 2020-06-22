class AddAvatarToParticipant < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :avatar, :string
  end
end
