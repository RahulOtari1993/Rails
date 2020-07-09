class Api::V1::ParticipantAccountController < Api::V1::BaseController
  include EndUserHelper

  ## Fetch Participant Details
  def show
    render_success 200, true, 'Details fetched successfully.', current_participant.as_json
  end

  ## Update Participant Profile Details
  def update
    participant = current_participant

    participant.assign_attributes(participant_params)
    participant.save(:validate => false)

    render_success 200, true, 'Profile updated successfully.', participant.as_json
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
    participant = current_participant

    if params[:participant][:social_type] == 'facebook'
      participant.facebook_uid = nil
      participant.facebook_token = nil
      participant.facebook_expires_at = nil
    elsif params[:participant][:social_type] == 'twitter'
      participant.twitter_uid = nil
      participant.twitter_token = nil
      participant.twitter_secret = nil
    end

    participant.save(:validate => false)
    render_success 200, true,
                   "#{params[:participant][:social_type].humanize} account disconnected successfully.",
                   participant.as_json
  end

  ## Fetch Email Settings of Participant
  def fetch_email_settings
    settings = EmailSetting.where(campaign_id: @campaign.id)

    render_success 200, true,'Email settings fetched successfully.', settings.as_json
  end

  ## Update Email Settings of Participant
  def update_email_settings
    settings = EmailSetting.where(campaign_id: @campaign.id).pluck(:id)

    if params[:participant][:email_setting_id].present? && settings.include?(params[:participant][:email_setting_id].to_i)
      current_participant.update_attribute(:email_setting_id, params[:participant][:email_setting_id].to_i)
      render_success 200, true,'Email setting updated successfully.', current_participant.as_json
    else
      return_error 500, false, 'Please select valid email setting.', {}
    end
  end

  private

    ## Strong Params for Participant
    def participant_params
      params.require(:participant).permit(:first_name, :last_name, :gender, :phone, :city, :age, :birth_date,
                                          :avatar, :state, :country, :postal, :address_1, :address_2, :bio, :home_phone,
                                          :work_phone, :job_position, :job_company_name, :job_industry)
    end

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
