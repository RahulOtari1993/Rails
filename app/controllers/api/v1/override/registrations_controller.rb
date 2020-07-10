class Api::V1::Override::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :validate_app_version

  def create
    begin
      sign_up_attributes = sign_up_params
      @resource = resource_class.where(organization_id: @organization.id, campaign_id: @campaign.id, email: params[:participant][:email]).first
      if (@resource.present? && (sign_up_attributes[:provider] == 'facebook' || sign_up_attributes[:provider] == 'google')) ||
          (sign_up_attributes[:provider] == 'facebook' || sign_up_attributes[:provider] == 'google')

        ## Only Allow Active & Opted Out Participants to Connect via Social Accounts
        render_inactive_auth_error and return unless (@resource.present? && @resource.active_for_authentication?)

        unless @resource.present?
          @resource = resource_class.new(email: sign_up_attributes[:email])
        end

        if sign_up_attributes[:provider] == 'facebook'
          render_params_error and return unless validate_facebook_params sign_up_attributes
          assign_facebook_params sign_up_attributes
        elsif sign_up_attributes[:provider] == 'google'
          render_params_error and return unless validate_google_params sign_up_attributes
          assign_google_params sign_up_attributes
        end

        assign_default_details ## Assign Default Details to Participant Object
        assign_new_tokens ## Set New Token to Participant Object

        @resource.skip_confirmation!
        if @resource.save!(:validate => false)
          store_device_details ## Store Device Details of Participant
          update_auth_header
          
          sign_in(:participant, @resource, store: false)
          @resource.connect_challenge_completed('', '')
          render_success 200, true, 'Signed in successfully.', @resource.as_json
        else
          return_error 500, false, 'Oops. Service Unavailable, please try again after some time.', {}
        end
      else
        if @resource.present? && sign_up_attributes[:provider] == 'email'
          ## Render Email Already Exists Error
          return_error 500, false, 'Email is already registered.', {}
        else
          ## Sign Up Participant With Email
          @resource = resource_class.new(sign_up_params)
          @resource.campaign_id = @campaign.id
          @resource.organization_id = @organization.id
          @resource.connect_type = @resource.provider

          if @resource.save!(:validate => false)
            store_device_details ## Store Device Details of Participant
            render_success 200, true, 'You will receive an email with instructions for how to confirm your email address in a few minutes.', @resource.as_json
          else
            return_error 500, false, 'Oops. Service Unavailable, please try again after some time.', {}
          end
        end
      end
    rescue Exception => e
      Rails.logger.info "ERROR: Sign Up API --> Message: #{e.message}"
      handle_runtime_error and return
    end
  end

  private

    ## Allows Participant Attributes
    def sign_up_params
      params.require(:participant).permit(:first_name, :last_name, :email, :uid, :provider, :password,
                                          :facebook_uid, :facebook_token, :facebook_expires_at, :google_uid,
                                          :google_token, :google_refresh_token, :google_expires_at, :remote_avatar_url)
    end

    ## Allows Device Attributes
    def device_params
      params.require(:token_data).permit(:os_type, :os_version, :device_id, :token, :token_type, :app_version)
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

    ## Render Params Error
    def render_params_error
      return return_error 400, false, 'Please pass required API params.', {}
    end

    ## Render Inactive Participant Authentication Failed Error
    def render_inactive_auth_error
      return return_error 401, false, 'Sorry! You are not authorised to Login.', {}
    end

    ## Handle Any Runtime Errors
    def handle_runtime_error
      return return_error 500, false, 'Oops. Service Unavailable, please try again after some time.', {}
    end

    ## Store Device Details of Participant
    def store_device_details
      if params[:token_data].present? && params[:token_data][:token].present?
        participant_device = ParticipantDeviceToken.where(token: params[:token_data][:token], participant_id: @resource.id).first

        ## Manage User Device Token Details
        if participant_device.present?
          participant_device.update_attributes(device_params)
        else
          ParticipantDeviceToken.create!(device_params.merge!({participant_id: @resource.id}))
        end
      end
    end
end
