class DeviseTokenAuthCreateParticipants < ActiveRecord::Migration[5.2]
  def change
    change_table :participants do |t|
      t.string :provider, :default => "email"
      t.string :uid
      t.text :tokens
    end

    add_index :participants, [:uid, :provider, :organization_id, :campaign_id], name: 'index_participant_uid_provider_org_campaign', unique: true
    add_index :participants, [:email, :organization_id, :campaign_id], name: 'index_participant_email_org_campaign', unique: true
    add_index :participants, :confirmation_token, unique: true
  end
end
