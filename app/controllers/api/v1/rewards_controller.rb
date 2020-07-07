class Api::V1::RewardsController < Api::V1::BaseController
  ## Fetch All Rewards of a Campaign
  def index
    render_success 200, true, 'Success', current_participant.as_json
  end

  ## Fetch Particular Reward Details
  def show
    render_success 200, true, 'Success', current_participant.as_json
  end
end
