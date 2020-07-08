class Api::V1::ParticipantAccountController < Api::V1::BaseController
  ## Fetch Participant Details
  def show
  end

  ## Update Participant Details
  def update
  end

  ## Connect Facebook Account
  def facebook
    render_params_error and return unless validate_facebook_params facebook_params

    participant = current_participant
    participant.assign_attributes(facebook_params)
    participant.email = ""

    participant.save(:validate => false)
    participant.connect_challenge_completed('', '', 'connect', 'facebook')

    render_success 200, true, 'Facebook account added successfully.', participant.as_json
  end

  ## Connect Twitter Account
  def twitter
  end

  ## Disconnect Social Accounts (Facebook/Twitter)
  def disconnect
  end

  private

    ## Strong Params for Facebook
    def facebook_params
      params.require(:participant).permit(:facebook_uid, :facebook_token, :facebook_expires_at)
    end

    ## Validate Facebook API Params
    def validate_facebook_params facebook_details
      keys = facebook_details.keys
      %w(facebook_uid facebook_token facebook_expires_at).all? { |s| keys.include?(s) }
    end
end
