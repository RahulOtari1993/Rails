class Api::V1::ChallengesController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch All Challenges of a Campaign
  def index
    challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select {|x| x.available? }
    render_success 200, true, 'Challenges fetched successfully.', challenges.as_json(type: 'list')
  end

  ## Fetch Particular Challenge Details
  def show
    challenge = @campaign.challenges.where(id: params[:id])
    render_success 200, true, 'Challenge details fetched successfully.', challenge.as_json(type: 'one')
  end
end
