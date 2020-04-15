ActiveAdmin.register OrganizationConfig do

  config.clear_action_items!
  actions :index, :edit, :update

  belongs_to :organization

  permit_params :facebook_app_id, :facebook_app_secret, :google_client_id, :google_client_secret, :organization_id

  index do
    selectable_column
    id_column
    column :facebook_app_id
    column :facebook_app_secret
    column :google_client_id
    column :google_client_secret
    actions
  end

  form do |f|
    f.inputs 'Organization Config Details' do
      f.input :facebook_app_id
      f.input :facebook_app_secret
      f.input :google_client_id
      f.input :google_client_secret
    end
    f.actions
  end

end
