ActiveAdmin.register Organization do

  permit_params :name, :sub_domain, :admin_user_id, :is_active

  index :download_links => false do
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
              collection: AdminUser.all.collect { |user| ["#{user.first_name} #{user.last_name}", user.id] },
              input_html: {required: true}
    end
    f.actions
  end

  sidebar 'Organization Details', only: [:show, :edit] do
    ul do
      li link_to 'Users', onboarding_organization_users_path(organization)
    end
  end

  controller do
    def update(options = {}, &block)
      super do |success, failure|
        if success.present?
          if resource.saved_change_to_sub_domain?
            ## Only Update Sub Domains if Org's Domain is Updated
            resource.campaigns.each do |campaign|
              if campaign.domain_type == 'sub_domain'
                sub_domain = "#{campaign.domain}"
              else
                sub_domain = "#{resource.sub_domain}#{campaign.domain}"
              end

              domain_list = DomainList.where(organization_id: resource.id, campaign_id: campaign.id).first
              if domain_list.present?
                domain_list.update(domain: sub_domain)
              end
            end
          end
        end

        block.call(success, failure) if block
        failure.html { render :edit }
      end
    end

    def destroy
      resource.update!(is_deleted: true, deleted_by: current_admin_user.id, is_active: false)

      ## Disable All Campaign & It's Challenges, Rewards & Participants
      resource.campaigns.each do |campaign|
        campaign.update(is_active: false)
        campaign.campaign_deactivation
      end

      ## Disable Org Admins
      resource.users.update_all(is_active: false)

      redirect_to onboarding_organizations_path
    end
  end
end
