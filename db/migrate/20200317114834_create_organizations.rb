class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :sub_domain, null: false
      t.references :admin_user, null: false

      t.boolean  :is_active, default: true, null: false
      t.boolean  :is_deleted, default: false, null: false
      t.integer  :deleted_by

      t.timestamps
    end
  end
end
