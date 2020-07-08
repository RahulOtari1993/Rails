class Api::V1::ParticipantAccountController < Api::V1::BaseController
  include EndUserHelper

  ## Fetch Participant Details
  def show
  end

  ## Update Participant Details
  def update
  end

  ## Connect Facebook Account
  def facebook
    facebook_challenge = display_facebook_button
    unless facebook_challenge.present?
      return return_error 500, false, 'No active challenge available for Facebook connect.', {}
    end
    participant = current_participant

    unless participant.eligible?(facebook_challenge)
      return return_error 500, false, 'You are not eligible for Facebook connect.', {}
    end

    render_params_error and return unless validate_facebook_params facebook_params

    participant.assign_attributes(facebook_params)
    participant.save(:validate => false)
    participant.connect_challenge_completed('', '', 'connect', 'facebook')

    render_success 200, true, 'Facebook account added successfully.', participant.as_json
  end

  ## Connect Twitter Account
  def twitter
    twitter_challenge = fetch_twitter_challenge
    unless twitter_challenge.present?
      return return_error 500, false, 'No active challenge available for Twitter connect.', {}
    end
    participant = current_participant

    unless participant.eligible?(twitter_challenge)
      return return_error 500, false, 'You are not eligible for Twitter connect.', {}
    end

    render_params_error and return unless validate_twitter_params twitter_params

    participant.assign_attributes(twitter_params)
    participant.save(:validate => false)
    participant.connect_challenge_completed('', '', 'connect', 'twitter')

    render_success 200, true, 'Twitter account added successfully.', participant.as_json
  end

  ## Disconnect Social Accounts (Facebook/Twitter)
  def disconnect
  end

  private

    ## Strong Params for Facebook
    def facebook_params
      params.require(:participant).permit(:facebook_uid, :facebook_token, :facebook_expires_at)
    end

    ## Strong Params for Twitter
    def twitter_params
      params.require(:participant).permit(:twitter_uid, :twitter_token, :twitter_secret)
    end

    ## Validate Facebook API Params
    def validate_facebook_params facebook_details
      keys = facebook_details.keys
      %w(facebook_uid facebook_token facebook_expires_at).all? { |s| keys.include?(s) }
    end

    ## Validate Twitter API Params
    def validate_twitter_params twitter_details
      keys = twitter_details.keys
      %w(twitter_uid twitter_token twitter_secret).all? { |s| keys.include?(s) }
    end
end
