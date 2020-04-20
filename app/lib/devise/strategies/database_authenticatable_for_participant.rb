module Devise
  module Models
    module DatabaseAuthenticatableForParticipant
      extend ActiveSupport::Concern
    end
  end

  module Strategies
    class DatabaseAuthenticatableForParticipant < Authenticatable

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
        if is_campaign_participant?(resource)
          check_subdomain_access(resource)
        else
          true
        end
      end

      ## CHeck if USer do Have Access on Sub Domain
      def check_subdomain_access(resource)
        subdomain = request.subdomain.split('.')
        organization = Organization.where(sub_domain: subdomain[0]).first
        campaign = Campaign.where(domain: subdomain[1]).first

        # domain = DomainList.where(domain: request.subdomain).first
        # campaign = nil
        # if domain.present?
        #   organization = Organization.where(id: domain.organization_id).first
        #   campaign = Campaign.where(id: domain.campaign_id).first
        # else
        #   organization = Organization.where(sub_domain: request.subdomain).first
        # end

        if organization.present? && campaign.present?
          # if campaign.present?
          #   camp_user = CampaignUser.where.not(role: 0).where(campaign_id: campaign.id, user_id: resource.id).first
          #   return camp_user.present?
          # end

          return is_campaign_participant?(resource)
        else
          return false
        end
      end

      ## Check if User is An Admin User
      def is_participant?(resource)
        return resource.class.name == 'Participant'
      end

      ## Check if User is An Organization Admin User
      # def is_org_admin?(resource, organization)
      #   OrganizationAdmin.where(organization_id: organization.id, user_id: resource.id).first
      # end

      ## Check if User is not Campaign Participant
      def is_campaign_participant?(resource)
        if is_participant?(resource)
          Campaign.joins(:campaigns_participants).where("campaigns_participants.particpant_id = #{resource.id} ")
        # Campaign.joins(:campaign).where(campaigns: {organization_id: organization.id, is_active: true},
        #                                     camparticipants: {user_id: resource.id}).where.not(campaign_users: {role: 0}).first
        end
      end
    end
  end
end
