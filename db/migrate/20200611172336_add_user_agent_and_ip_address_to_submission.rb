class AddUserAgentAndIpAddressToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :user_agent, :text
    add_column :submissions, :ip_address, :string

    rename_column :participant_actions, :useragent, :user_agent
    rename_column :participant_actions, :ipaddress, :ip_address
  end
end
