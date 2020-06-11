class AddUserAgentAndIpAddressToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :useragent, :text
    add_column :submissions, :ipaddress, :string
  end
end
