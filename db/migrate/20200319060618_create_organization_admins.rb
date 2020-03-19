class CreateOrganizationAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_admins do |t|
      t.references :organization, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
