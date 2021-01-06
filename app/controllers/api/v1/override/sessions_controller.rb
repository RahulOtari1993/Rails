class Api::V1::Override::SessionsController < DeviseTokenAuth::SessionsController
  before_action :validate_app_version

  def create
    begin
      param_hash = sign_in_params
      validate_params param_hash
      render_params_error and return unless validate_params param_hash

      @resource = resource_class.where(organization_id: @organization.id, campaign_id: @campaign.id, email: param_hash[:email]).first

      ## Check if Participant Exists or Not
      render_auth_error and return unless @resource

      ## Only Allow Active & Opted Out Participants to Login
      render_inactive_auth_error and return unless @resource.active_for_authentication?

      if @resource.valid_password?(param_hash[:password])
        assign_new_tokens ## Set New Token to Participant Object
        @resource.save

        store_device_details ## Store Device Details of Participant
        sign_in(:participant, @resource, store: false)
        log_action ## Create participant Login Audit Log

        ## Check onboarding has submitted or not
        submitted = false
        onboarding_challenge = @campaign.challenges.current_active.where(challenge_type: 'collect', parameters: 'profile').first
        if onboarding_challenge.present?
          submitted =  Submission.where(campaign_id:  @campaign.id, participant_id: @resource.id, challenge_id: onboarding_challenge.id).present?
        end
        response = @resource.as_json
        response.merge!({is_onboarding_questions_answered: submitted})

        render_success 200, true, 'Signed in successfully.', { participant: response }
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

    ## Allows Device Attributes
    def device_params
      params.require(:token_data).permit(:os_type, :os_version, :device_id, :token, :token_type, :app_version)
    end

    ## Validate Sign In API Params
    def validate_params params_list
      keys = params_list.keys
      %w(email password).all? { |s| keys.include?(s) }
    end

    ## Render Params Error
    def render_params_error
      return return_error 400, false, 'Please pass required API params.', {}
    end

    ## Render Authentication Failed Error
    def render_auth_error
      return return_error 401, false, 'Invalid email or password.', {}
    end

    ## Render Inactive Participant Authentication Failed Error
    def render_inactive_auth_error
      return return_error 401, false, 'Sorry! You are not authorised to Login.', {}
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

    ## Handle Any Runtime Errors
    def handle_runtime_error
      return return_error 500, false, 'Oops. Service Unavailable, please try again after some time.', {}
    end

    ## Create participant Login Audit Log
    def log_action
      ParticipantAction.create({participant_id: @resource.id, points: 0, action_type: 'sign_in',
                                title: 'Signed in', campaign_id: @resource.campaign_id})
    end
end
