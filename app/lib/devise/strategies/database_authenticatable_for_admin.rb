module Devise
  module Strategies

    class DatabaseAuthenticatableForAdmin < Authenticatable

      # This code is mostly copied from Devise, but except the authentication of devise
      # the class includes this module should define a method 'custom_validate(resource)' to
      # provide other validates, for example if the resource is admin, or if th resource is
      # an owner of a merchant etc..
      def authenticate!
        resource  = valid_password? && mapping.to.find_for_database_authentication(authentication_hash)
        encrypted = false

        if validate(resource){ encrypted = true; resource.valid_password?(password) } &&
          custom_validate(resource)
          resource.after_database_authentication
          success!(resource)
        else
          mapping.to.new.password = password if !encrypted && Devise.paranoid
          fail(:not_found_in_database)
          halt!
        end
      end

      def custom_validate(resource)
        if is_admin_user?(resource)
          has_access = check_subdomain_access(resource)
          return false unless has_access
          merchant.owner?(resource)
        else
          true
        end
      end

      def check_subdomain_access(resource)
        @domain = DomainList.where(domain: request.subdomain).first
        @campaign = nil

        if @domain.present?
          @organization = Organization.where(id: @domain.organization_id).first
          @campaign = Campaign.where(id: @domain.campaign_id).first
        else
          @organization = Organization.where(sub_domain: request.subdomain).first
        end

        if @organization.present?
          if @campaign.present?
            camp_user = CampaignUser.where.not(role: 'participent').where(campaign_id: @campaign.id, user_id: resource.id).first
            if camp_user
              return true
            else
              return false
            end
          end
          @org_admin = OrganizationAdmin.where(organization_id: @organization.id, user_id: resource.id).first

          if @org_admin.present?
            return true
          else
            return false
          end
        else
          return false
        end
      end

      def is_admin_user?(resource)
        return resource.role == 'admin'
      end

    end
  end
end
