class CreateOrganizationAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_admins do |t|
      t.references :organization, null: false
      t.references :user, null: false

      t.boolean  :is_active, default: false, null: false
      t.boolean  :is_deleted, default: false, null: false
      t.integer  :deleted_by

      t.timestamps
    end
  end
end
