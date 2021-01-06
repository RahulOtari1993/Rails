class Api::V1::HomeController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch Challenges of a Campaign for ome screen
  def index
    challenges = @campaign.challenges
    rewards = @campaign.rewards

    featured_challenges = challenges.featured.where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? }
    ## fetch current active upcoming challenge
    submitted_challenge_ids = @campaign.submissions.where(participant_id: current_participant.id).pluck(:challenge_id)
    current_challenge = challenges.current_active.where.not(id: submitted_challenge_ids).where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? && (x.start.strftime('%H:%M:%S') > DateTime.now.strftime('%H:%M:%S')) }.sort_by{ |x| x.start.strftime('%H:%M:%S') }.first

    ## fetch current active upcoming reward
    claimed_reward_ids = @campaign.participant_actions.where(participant_id: current_participant.id, actionable_type: "Reward").pluck(:actionable_id).uniq
    current_reward = rewards.current_active.active.where.not(id: claimed_reward_ids).select { |x| x.available? && (x.start.strftime('%H:%M:%S') > DateTime.now.strftime('%H:%M:%S')) }.sort_by{ |x| x.start.strftime('%H:%M:%S') }.first

    render_success 200, true, 'Challenges fetched successfully.', {
                                        featured_challenges: featured_challenges.as_json(type: 'list'),
                                        current_challenge: current_challenge.present? ? current_challenge.as_json(type: 'list') : {},
                                        current_reward: current_reward.present? ? current_reward.as_json(type: 'list') : {}
                                }
  end


end
