class AddIsConnectedToNetworks < ActiveRecord::Migration[5.2]
  def change
    add_column :networks, :is_disconnected, :boolean, default: false

    Network.all.each do |network|
      network.update({is_disconnected: true}) unless network.auth_token.present? && network.expires_at.present?
    end
  end
end
