class Participants::ParticipantAccountsController < ApplicationController
  before_action :authenticate_participant!

  ## Fetch Details of reward
  def details_form
    @email_settings = @campaign.email_settings
  end

  def update_profile_details
    if current_participant.update(participant_params)
      profile_attribute = @campaign.profile_attributes.where(attribute_name: "affiliation").first
      unless (params[:affiliation_types].blank? || profile_attribute.blank?)
        ## delete existing partcipant profiles
        current_participant.participant_profiles.destroy_all
        ## create new selected participant profiles
        params[:affiliation_types].each do |item|
          participant_profile = current_participant.participant_profiles.new(profile_attribute_id: profile_attribute.id, value: item)
          participant_profile.save
        end
      end
    end
  end

  ## Disconnect Existing Connected Social Media Account
  def disconnect
    participant = current_participant

    if params[:connection_type] == 'facebook'
      participant.facebook_uid = nil
      participant.facebook_token = nil
      participant.facebook_expires_at = nil
    elsif params[:connection_type] == 'twitter'
      participant.twitter_uid = nil
      participant.twitter_token = nil
      participant.twitter_secret = nil
    end

    if participant.save(:validate => false)
      redirect_to root_path, notice: "#{params[:connection_type].humanize} account disconnected successfully"
    else
      redirect_to root_path, alert: "#{params[:connection_type].humanize} account disconnect failed"
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :address_1,
                                            :address_2, :city, :state, :postal, :country, :phone, :avatar,
                                            :home_phone, :work_phone, :job_position, :job_company_name, :job_industry, :email_setting_id)
  end

end
