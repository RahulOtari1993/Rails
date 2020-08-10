class AddTimestampsToSuperAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :created_at, :datetime
    add_column :admin_users, :updated_at, :datetime

    AdminUser.update_all(created_at: Time.now, updated_at: Time.now)
  end
end
