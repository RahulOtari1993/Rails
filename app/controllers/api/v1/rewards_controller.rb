class Api::V1::RewardsController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch All Rewards of a Campaign
  def index
    rewards = @campaign.rewards.current_active.select {|x| x.available? }
    render_success 200, true, 'Rewards fetched successfully.', rewards.as_json
  end

  ## Fetch Particular Reward Details
  def show
    reward = @campaign.rewards.where(id: params[:id])
    render_success 200, true, 'Reward details fetched successfully.', reward.as_json
  end
end
