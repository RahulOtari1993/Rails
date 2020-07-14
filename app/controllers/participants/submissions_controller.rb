class Participants::SubmissionsController < ApplicationController
  layout 'non_login_submission'

  ## Used for Non Logged In Users to Submit Challenges
  def load_details
    if params[:type] == 'challenge' && params[:identifier].present?
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials[Rails.env.to_sym][:encryption_key])

      ## Encrypt in URI Format & Pass in URL
      # encrypted_data = crypt.encrypt_and_sign('C9E392FF81C29b00130abbfb')
      # encrypted_data = URI.encode_www_form_component(encrypted_data)

      identifier = crypt.decrypt_and_verify(params[:identifier])
      participant_id = identifier[0, 12]
      challenge_id = identifier[12, 24]

      @participant = Participant.where(p_id: participant_id.to_s).first
      @challenge = Challenge.where(identifier: challenge_id.to_s).first
      @challenge_activity = @campaign.participant_actions
                                .where(participant_id: @participant.id, actionable_id: @challenge.id, actionable_type: "Challenge").first
    end
  end
end
