class AddEmailSettingIdToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :email_setting_id, :integer
  end
end
