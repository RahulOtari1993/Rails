ActiveAdmin.register User do

  belongs_to :organization

  permit_params :first_name, :last_name, :email, :is_active, :organization_id, :is_invited, :invited_by_id, :role

  index :download_links => false do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :is_active
    column :is_deleted
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
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

      f.input :confirmed_at, :input_html => {:value => Time.now},
              as: :hidden

      f.input :is_active, :input_html => {:value => false},
              as: :hidden

      f.input :role, :input_html => {:value => 'admin'},
              as: :hidden
    end
    f.actions
  end

  controller do
    # def update_resource(object, attributes)
    #   update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
    #   object.send(update_method, *attributes)
    # end

    def create
      user = User.new(user_params)
      if user.save(:validate => false)
        user.send_reset_password_instructions
      end
    end

    def destroy
      resource.update!(is_deleted: true, deleted_by: current_admin_user.id, is_active: false)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :organization_id, :is_invited, :invited_by_id,
                                       :is_active, :role, :confirmed_at)
    end
  end
end
