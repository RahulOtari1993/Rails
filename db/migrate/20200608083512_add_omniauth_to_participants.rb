class AddOmniauthToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :oauth_token, :string
    add_column :participants, :oauth_expires_at, :datetime
    add_column :participants, :provider, :string
    add_column :participants, :uid, :string
  end
end
