module Devise
  module Models
    module DatabaseAuthenticatableForAdmin
      extend ActiveSupport::Concern
    end
  end

  module Strategies
    class DatabaseAuthenticatableForAdmin < Authenticatable

      def authenticate!
        resource  = valid_password? && mapping.to.find_for_authentication(authentication_hash)
        encrypted = false

        if validate(resource){ encrypted = true; resource.valid_password?(password) } && custom_validate(resource)
          resource.after_database_authentication
          success!(resource)
        else
          mapping.to.new.password = password if !encrypted && Devise.paranoid
          fail(:not_found_in_database)
          halt!
        end
      end

      ## Custom Login To Validate a User
      def custom_validate(resource)
        if is_admin_user?(resource)
          check_subdomain_access(resource)
        else
          true
        end
      end

      ## CHeck if USer do Have Access on Sub Domain
      def check_subdomain_access(resource)
        organization = Organization.where(sub_domain: request.subdomain).first

        # domain = DomainList.where(domain: request.subdomain).first
        # campaign = nil
        # if domain.present?
        #   organization = Organization.where(id: domain.organization_id).first
        #   campaign = Campaign.where(id: domain.campaign_id).first
        # else
        #   organization = Organization.where(sub_domain: request.subdomain).first
        # end

        if organization.present?
          # if campaign.present?
          #   camp_user = CampaignUser.where.not(role: 0).where(campaign_id: campaign.id, user_id: resource.id).first
          #   return camp_user.present?
          # end
          org_admin = OrganizationAdmin.where(organization_id: organization.id, user_id: resource.id).first

          return org_admin.present?
        else
          return false
        end
      end

      ## Check if User is An Admin User
      def is_admin_user?(resource)
        return resource.role == 'admin'
      end

    end
  end
end
