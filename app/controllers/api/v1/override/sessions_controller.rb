class Api::V1::Override::SessionsController < DeviseTokenAuth::SessionsController
  before_action :validate_app_version

  def create
    begin
      param_hash = sign_in_params
      validate_params param_hash
      render_params_error unless validate_params param_hash

      @resource = resource_class.where(organization_id: @organization.id, campaign_id: @campaign.id, email: param_hash[:email]).first

      ## Check if Participant Exists or Not
      render_auth_error and return unless @resource

      ## Only Allow Active & Opted Out Participants to Login
      render_inactive_auth_error and return unless @resource.active_for_authentication?

      if @resource.valid_password?(param_hash[:password])
        # Create client id
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @resource.save
        sign_in(:participant, @resource, store: false)

        render_success 200, true, 'Signed in successfully.', @resource.as_json
      else
        render_auth_error
      end
    rescue Exception => e
      Rails.logger.info "ERROR: Sign In API --> Message: #{e.message}"
      handle_runtime_error and return
    end
  end

  private

    ## Allows Participant Attributes
    def sign_in_params
      params.require(:participant).permit(:email, :password)
    end

    ## Validate Sign In API Params
    def validate_params params_list
      keys = params_list.keys
      %w(email password).all? { |s| keys.include?(s) }
    end

    ## Render Params Error
    def render_params_error
      return return_error 500, false, 'Please pass required API params.', {}
    end

    ## Render Authentication Failed Error
    def render_auth_error
      return return_error 500, false, 'Invalid email or password.', {}
    end

    ## Render Inactive Participant Authentication Failed Error
    def render_inactive_auth_error
      return return_error 500, false, 'Sorry! You are not authorised to Login.', {}
    end

    ## Handle Any Runtime Errors
    def handle_runtime_error
      return return_error 500, false, 'Oops. Service Unavailable, please try again after some time.', {}
    end
end