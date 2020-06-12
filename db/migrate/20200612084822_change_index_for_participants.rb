class ChangeIndexForParticipants < ActiveRecord::Migration[5.2]
  def change
    remove_index :participants, name: "index_participants_on_email_and_organization_id"

    add_index :participants, [:email, :organization_id, :campaign_id], unique: true
  end
end
