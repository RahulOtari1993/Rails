class CreateParticipantDeviceTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_device_tokens do |t|
      t.integer :participant_id
      t.string  :os_type
      t.string  :os_version
      t.string  :device_id
      t.string  :token
      t.string  :token_type
      t.string  :device_arn
      t.string  :app_version
      t.string  :state

      t.timestamps
    end
  end
end
