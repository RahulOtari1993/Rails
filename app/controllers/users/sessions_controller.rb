class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :check_availability, only: [:new]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def check_availability
    domain = request.domain
    sub_domain = request.subdomain

    ## Check whether to Check with Domain or Sub Domain
    if sub_domain.empty? && domain.present?
      @domain = DomainList.where(domain: domain).first
    elsif sub_domain.present? && domain.present?
      @domain = DomainList.where(domain: sub_domain).first
    end

    if @domain.present?
      @organization = Organization.active.where(id: @domain.organization_id).first
      @campaign = Campaign.active.where(id: @domain.campaign_id).first

      unless @campaign.present?
        redirect_to not_found_path
      end
    else
      @organization = Organization.active.where(sub_domain: request.subdomain).first
    end

    unless @organization.present?
      unless request.path.start_with?( '/onboarding')
        redirect_to not_found_path
      end
    end
  end

  def set_organization
    @domain = DomainList.where(domain: request.subdomain).first
    if @domain.present?
      @organization = Organization.active.where(id: @domain.organization_id).first
      @campaign = Campaign.active.where(id: @domain.campaign_id).first
    else
      @organization = Organization.active.where(sub_domain: request.subdomain).first
    end
  end

  def after_sign_in_path_for(resource)
    ## Check & Set Organization, If organization object in NIL
    set_organization if @organization.nil?

    if resource.organization_admin?(@organization) #resource.is_invited?
      ## If User is Org Admin, Redirect him to Campaings Listing Page
      admin_organizations_campaigns_path
    else
      ## Check If User if Not a Campaign Participant
      campaign_user = resource.campaign_users @organization
      if campaign_user.count > 0

        if campaign_user.count == 1
          ## If User belongs to only one Campaign, Redirect to Campaign Dashboard Page
          admin_campaign_dashboard_path(campaign_user.first.campaign)
        else
          ## If User belongs to many Campaign, Redirect to Campaign List Page
          admin_organizations_campaigns_path
        end
      else
        root_url
      end
    end
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource)
    request.referrer
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
