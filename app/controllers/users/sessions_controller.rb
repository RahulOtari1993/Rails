class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

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

  def after_sign_in_path_for(resource)
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

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
