ActiveAdmin.register User do

  belongs_to :organization

  permit_params :first_name, :last_name, :email, :is_active, :organization_id, :is_invited, :invited_by_id

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :sub_domain
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs 'User Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :organization_id, collection: [[f.object.organization.name, f.object.organization.id]],
              :as => :hidden
      f.input :is_invited, :input_html => {:value => true},
              as: :hidden

      f.input :invited_by_id, :input_html => {:value => current_admin_user.id},
              as: :hidden
    end
    f.actions
  end

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
end
