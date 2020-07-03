class Participants::ParticipantAccountsController < ApplicationController
  before_action :authenticate_participant!

  ## Fetch Details of reward
  def details_form

  end

  def update_profile_details
    @participant = current_participant
    @participant.update(participant_params)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :address_1,
                                            :address_2, :city, :state, :postal, :country, :phone, :avatar,
                                            :home_phone, :work_phone, :job_position, :job_company_name, :job_industry)
  end

end
