class Api::V1::Override::RegistrationsController < DeviseTokenAuth::RegistrationsController
  ## Create a New User With Email
  def create
    binding.pry
    sign_up_attributes = sign_up_params
    @resource = resource_class.where(organization_id: @organization.id, campaign_id: @campaign.id, email: params[:participant][:email]).first
    if @resource.present?
      if (sign_up_attributes[:params] == 'facebook' || sign_up_attributes[:params] == 'google')

      else
        ## Render Email Already Exists Error
      end
    else
      @resource = resource_class.new(sign_up_params)
      @resource.uid = @resource.email
      @resource.password = Devise.friendly_token[0, 20] if @resource == 'facebook' || @resource == 'google'
    end


    binding.pry

    begin
      if @resource.save
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }

        if params[:participant][:image].present?
          ## Image Upload from Image Object
        elsif params[:participant][:image].present?
          ## Image Upload from Remote URL
        end


        @resource.save!
        update_auth_header

        ## Store Device Details
        if params[:token_data].present?

          if Rails.env != 'development'
            params[:token_data] = JSON.parse params[:token_data].gsub('=>', ':')
          end

          if params[:token_data][:token].present?
            user_device = UserDeviceToken.where(token: params[:token_data][:token], user_id: @resource.id)

            ## Manage User Device Token Details
            if user_device.present?
              user_device.first.update_attributes(device_params)

              ## Used When Configuring Push Notifications
              user_device.first.manage_aws_arn
            else
              user_device = UserDeviceToken.create!(device_params.merge!({user_id: @resource.id}))

              ## Used When Configuring Push Notifications
              user_device.manage_aws_arn
            end
          end
        end

        render_create_succes
      else
        clean_up_passwords @resource
        render_create_error
      end
    rescue ActiveRecord::RecordNotUnique
      clean_up_passwords @resource
      render_create_error
    end
  end

  private

    ## Allows Participant Attributes
    def sign_up_params
      params.require(:participant).permit(:first_name, :last_name, :email, :uid, :provider,
                                          :facebook_uid, :facebook_token, :facebook_expires_at, :google_uid,
                                          :google_token, :google_refresh_token, :google_expires_at)
    end

    ## Allows Device Attributes
    def device_params
      params.require(:token_data).permit(:device_id, :token, :os_type, :os_version, :app_version, :token_type)
    end
end
