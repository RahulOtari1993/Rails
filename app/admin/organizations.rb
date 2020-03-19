ActiveAdmin.register Organization do

  permit_params :name, :sub_domain, :admin_user_id, :is_active

  index do
    selectable_column
    id_column
    column :name
    column :sub_domain
    column :is_active
    column :created_at
    actions do |organization|
      raw("#{link_to 'View Users', onboarding_organization_users_path(organization)}")
    end
  end

  filter :name
  filter :sub_domain
  filter :is_active
  filter :created_at

  form do |f|
    f.inputs 'Organization Details' do
      f.input :name, input_html: {required: true}
      f.input :sub_domain, input_html: {required: true}
      f.input :is_active
      f.input :admin_user_id, as: :select,
              collection: AdminUser.all.collect {|user| ["#{user.first_name} #{user.last_name}", user.id] },
              input_html: {required: true}
    end
    f.actions
  end

  def destroy
    resource.update!(is_deleted: true, deleted_by: current_admin_user.id)
    redirect_to onboarding_organizations_path
  end

end
