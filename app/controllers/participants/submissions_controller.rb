class Participants::SubmissionsController < ApplicationController

  ## Used for Non Logged In Users to Submit Challenges
  def load_details
    if params[:type] == 'challenge' && params[:identifier].present?
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials[Rails.env.to_sym][:encryption_key])
      encrypted_data = crypt.encrypt_and_sign('C9E392FF81C2fd9eef68649')

      decrypted_back = crypt.decrypt_and_verify(encrypted_data)
    end
  end
end
