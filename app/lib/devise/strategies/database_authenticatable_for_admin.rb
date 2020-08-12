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
        organization = Organization.active.where(sub_domain: request.subdomain).first

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

          return is_org_admin?(resource, organization) || is_campaign_user?(resource, organization)
        else
          return false
        end
      end

      ## Check if User is An Admin User
      def is_admin_user?(resource)
        return resource.role == 'admin'
      end

      ## Check if User is An Organization Admin User
      def is_org_admin?(resource, organization)
        OrganizationAdmin.where(organization_id: organization.id, user_id: resource.id).first
      end

      ## Check if User is not Campaign Participant
      def is_campaign_user?(resource, organization)
        CampaignUser.joins(:campaign).where(campaigns: {organization_id: organization.id, is_active: true},
                                            campaign_users: {user_id: resource.id}).where.not(campaign_users: {role: 0}).first
      end
    end
  end
end
