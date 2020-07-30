class Participants::RewardsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_reward

  ## Fetch Details of reward
  def details
    @reward_activity = @campaign.participant_actions.where(participant_id: current_participant.id, actionable_id: @reward.id, actionable_type: "Reward").first
    @reward_rules_info = @reward.fetch_reward_rules_criteria(current_participant) if @reward.selection == 'milestone'
  end

  ## Claim Reward
  def claim
    ## check reward and available quantity
    if @reward.present? && (@reward.limit.to_i > @reward.claims)
      ## process the service to claim reward and participate action entries
      reward_service = RewardsService.new(current_participant.id, @reward.id, request, current_visit)
      response = reward_service.process
    else
      response = {success: false, message: 'Reward not found, Please contact administrator.'}
    end

    respond_to do |format|
      format.json { render json: response }
      format.js { render layout: false }
    end
  end


  private
    ## Set Reward
    def set_reward
      @reward = Reward.where(id: params[:id]).first rescue nil
    end
end
