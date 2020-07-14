class Api::V1::RewardsController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_reward, only: [:show, :claim]

  ## Fetch All Rewards of a Campaign
  def index
    rewards = @campaign.rewards.current_active.select { |x| x.available? }
    rewards = Kaminari.paginate_array(rewards).page(page).per(per_page)
    set_pagination_header(rewards)

    render_success 200, true, 'Rewards fetched successfully.', rewards.as_json(type: 'list')
  end

  ## Fetch Particular Reward Details
  def show
    render_success 200, true, 'Reward details fetched successfully.', @reward.as_json(type: 'one')
  end

  ## Claim Reward
  def claim
    ## Check Reward and Available Quantity
    if @reward.present? && (@reward.limit.to_i > @reward.claims)
      ## Execute Reward Service to Claim Reward and Create Entries of Participate Action
      reward_service = RewardsService.new(current_participant.id, @reward.id, request)
      response = reward_service.process
      if response[:success]
        render_success 200, true, response[:message], {}
      else
        return_error 500, false, response[:message], {}
      end
    else
      render_success 200, true, 'Reward not found, Please contact administrator.', {}
    end
  end

  private

  ## Set Reward
  def set_reward
    @reward = @campaign.rewards.where(id: params[:id]).first
  end
end
