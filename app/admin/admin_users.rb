ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :is_active

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :is_active
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :is_active
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'User Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :is_active
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    # def index
    #   index! do |format|
    #     @admin_users = AdminUser.available.page(params[:page])
    #     format.html
    #   end
    # end

    def destroy
      resource.update!(is_deleted: true, deleted_by: current_admin_user.id)
      redirect_to onboarding_admin_users_path
    end
  end

end
