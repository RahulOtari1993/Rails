class Api::V1::Override::RegistrationsController < DeviseTokenAuth::RegistrationsController
  ## Create a New User With Email
  def create
    sign_up_attributes = sign_up_params
    @resource = resource_class.where(organization_id: @organization.id, campaign_id: @campaign.id, email: params[:participant][:email]).first
    if (@resource.present? && (sign_up_attributes[:provider] == 'facebook' || sign_up_attributes[:provider] == 'google')) ||
        (sign_up_attributes[:provider] == 'facebook' || sign_up_attributes[:provider] == 'google')

      unless @resource.present?
        @resource = Participant.new(email: sign_up_attributes[:email])
      end

      if sign_up_attributes[:provider] == 'facebook'
        unless validate_facebook_params sign_up_attributes
          return return_error 500, false, 'Please pass required API params', {}
        end
        assign_facebook_params sign_up_attributes
      elsif sign_up_attributes[:provider] == 'google'
        unless validate_google_params sign_up_attributes
          return return_error 500, false, 'Please pass required API params', {}
        end
        assign_google_params sign_up_attributes
      end

      assign_default_details ## Assign Default Details to Participant Object
      assign_new_tokens ## Set New Token to Participant Object

      @resource.skip_confirmation!
      if @resource.save(:validate => false)
        update_auth_header
        sign_in(:participant, @resource, store: false)
        # @resource.connect_challenge_completed('', '')
        render_success 200, true, 'Logged in successfully', @resource.as_json
      else
        return_error 500, false, 'Failed', {}
      end

    else
      binding.pry
      if sign_up_attributes[:provider] == 'email'
        ## Sign Up Participant With Email
      else
        ## Render Email Already Exists Error
        return_error 500, false, 'Email is already registered', {}
      end
    end

    # begin
    #   if @resource.save
    #     @client_id = SecureRandom.urlsafe_base64(nil, false)
    #     @token = SecureRandom.urlsafe_base64(nil, false)
    #
    #     @resource.tokens[@client_id] = {
    #         token: BCrypt::Password.create(@token),
    #         expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    #     }
    #
    #     if params[:participant][:image].present?
    #       ## Image Upload from Image Object
    #     elsif params[:participant][:image].present?
    #       ## Image Upload from Remote URL
    #     end
    #
    #
    #     @resource.save!
    #     update_auth_header
    #
    #     ## Store Device Details
    #     if params[:token_data].present?
    #
    #       if Rails.env != 'development'
    #         params[:token_data] = JSON.parse params[:token_data].gsub('=>', ':')
    #       end
    #
    #       if params[:token_data][:token].present?
    #         user_device = UserDeviceToken.where(token: params[:token_data][:token], user_id: @resource.id)
    #
    #         ## Manage User Device Token Details
    #         if user_device.present?
    #           user_device.first.update_attributes(device_params)
    #
    #           ## Used When Configuring Push Notifications
    #           user_device.first.manage_aws_arn
    #         else
    #           user_device = UserDeviceToken.create!(device_params.merge!({user_id: @resource.id}))
    #
    #           ## Used When Configuring Push Notifications
    #           user_device.manage_aws_arn
    #         end
    #       end
    #     end
    #
    #     render_create_succes
    #   else
    #     clean_up_passwords @resource
    #     render_create_error
    #   end
    # rescue ActiveRecord::RecordNotUnique
    #   clean_up_passwords @resource
    #   render_create_error
    # end
  end

  private

    ## Allows Participant Attributes
    def sign_up_params
      params.require(:participant).permit(:first_name, :last_name, :email, :uid, :provider,
                                          :facebook_uid, :facebook_token, :facebook_expires_at, :google_uid,
                                          :google_token, :google_refresh_token, :google_expires_at, :remote_avatar_url)
    end

    ## Allows Device Attributes
    def device_params
      params.require(:token_data).permit(:device_id, :token, :os_type, :os_version, :app_version, :token_type)
    end

    ## Validate Facebook API Params
    def validate_facebook_params facebook_details
      keys = facebook_details.keys
      %w(facebook_uid facebook_token facebook_expires_at first_name email).all? { |s| keys.include?(s) }
    end

    ## Validate Google API Params
    def validate_google_params google_details
      keys = google_details.keys
      %w(google_uid google_token google_expires_at first_name email).all? { |s| keys.include?(s) }
    end

    ## Assign Facebook Params
    def assign_facebook_params facebook_params
      attributes = {}
      %w(facebook_uid facebook_token facebook_expires_at first_name last_name provider remote_avatar_url).each do |key|
        attributes[key] = facebook_params[key] if facebook_params[key].present?
      end

      @resource.assign_attributes(attributes)
    end

    ## Assign Google Params
    def assign_google_params google_params
      attributes = {}
      %w(google_uid google_token google_expires_at google_refresh_token first_name last_name provider remote_avatar_url).each do |key|
        attributes[key] = google_params[key] if google_params[key].present?
      end

      @resource.assign_attributes(attributes)
    end

    ## Assign Default Details
    def assign_default_details
      @resource.campaign_id = @campaign.id
      @resource.organization_id = @organization.id
      @resource.connect_type = @resource.provider
      @resource.uid = @resource.email
      @resource.status = 1
    end

    ## Assign New Tokens
    def assign_new_tokens
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token = SecureRandom.urlsafe_base64(nil, false)
      @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }
    end
end
