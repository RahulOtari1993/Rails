class GoogleOAuthColumnsForParticipant < ActiveRecord::Migration[5.2]
  def change
    remove_column :participants, :oauth_token
    remove_column :participants, :oauth_expires_at
    remove_column :participants, :provider
    remove_column :participants, :uid

    ## Facebook Auth Columns
    add_column :participants, :facebook_uid, :string
    add_column :participants, :facebook_token, :string
    add_column :participants, :facebook_expires_at, :datetime

    ## Google Auth Columns
    add_column :participants, :google_uid, :string
    add_column :participants, :google_token, :string
    add_column :participants, :google_refresh_token, :string
    add_column :participants, :google_expires_at, :datetime
  end
end
