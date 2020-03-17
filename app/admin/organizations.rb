ActiveAdmin.register Organization do

  permit_params :name, :sub_domain, :admin_user_id

  index do
    selectable_column
    id_column
    column :name
    column :sub_domain
    column :created_at
    actions
  end

  filter :name
  filter :sub_domain
  filter :created_at

  form do |f|
    f.inputs 'Org Details' do
      f.input :name, input_html: {required: true}
      f.input :sub_domain, input_html: {required: true}
      f.input :admin_user_id, :as => :select, :collection => AdminUser.all.collect {|product| [product.first_name, product.id] }, input_html: {required: true}
    end
    f.actions
  end

end
