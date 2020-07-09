class Api::V1::ChallengesController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch All Challenges of a Campaign
  def index
    challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select {|x| x.available? }
    challenges = Kaminari.paginate_array(challenges).page(page).per(per_page)
    set_pagination_header(challenges)

    render_success 200, true, 'Challenges fetched successfully.', challenges.as_json(type: 'list')
  end

  ## Fetch Particular Challenge Details
  def show
    challenge = @campaign.challenges.where(id: params[:id])
    render_success 200, true, 'Challenge details fetched successfully.', challenge.as_json(type: 'one')
  end

  ## Fetch Active Connect Challenges (Facebook, Google & Twitter)
  def connect_challenges
    challenges = @campaign.challenges.current_active
        .where(challenge_type: ['signup', 'connect'], parameters: ['facebook', 'google', 'twitter'])

    render_success 200, true, 'Connect Challenge details fetched successfully.', challenges.as_json(type: 'list')
  end
end
