class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :sub_domain, null: false
      t.references :admin_user, null: false

      t.timestamps
    end
  end
end
