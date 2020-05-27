ActiveAdmin.register Configuration do
  config.filters = false
  actions :all, :except => [:destroy]

  permit_params :facebook_app_id, :facebook_app_secret, :google_client_id, :google_client_secret, :twitter_app_id, :twitter_app_secret

  index do
    selectable_column
    id_column
    column :facebook_app_id
    column :facebook_app_secret
    column :google_client_id
    column :google_client_secret
    column :twitter_app_id
    column :twitter_app_secret
    actions
  end

  form do |f|
    f.inputs 'Configuration Details' do
      f.input :facebook_app_id
      f.input :facebook_app_secret
      f.input :google_client_id
      f.input :google_client_secret
      f.input :twitter_app_id
      f.input :twitter_app_secret
    end
    f.actions
  end

end
