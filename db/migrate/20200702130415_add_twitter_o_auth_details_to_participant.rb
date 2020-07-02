class AddTwitterOAuthDetailsToParticipant < ActiveRecord::Migration[5.2]
  def change
    ## Twitter Auth Columns
    add_column :participants, :twitter_uid, :string
    add_column :participants, :twitter_token, :string
    add_column :participants, :twitter_secret, :string
  end
end
