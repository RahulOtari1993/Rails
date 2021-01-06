class Api::V1::HomeController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch Challenges of a Campaign for ome screen
  def index
    challenges = @campaign.challenges
    featured_challenges = challenges.featured.where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? }
    current_month_challenges = challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? }

    render_success 200, true, 'Challenges fetched successfully.', {
                                        featured_challenges: featured_challenges.as_json(type: 'list'),
                                        current_month_challenges: current_month_challenges.as_json(type: 'list')
                                }
  end


end
