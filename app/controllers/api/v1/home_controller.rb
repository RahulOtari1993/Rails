class Api::V1::HomeController < Api::V1::BaseController
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  ## Fetch Challenges of a Campaign for ome screen
  def index
    challenges = @campaign.challenges
    rewards = @campaign.rewards

    submitted_challenge_ids = @campaign.submissions.where(participant_id: current_participant.id).pluck(:challenge_id)

    ## Featured Challenges
    featured_challenges = challenges.current_active.featured.where.not(id: submitted_challenge_ids).where(challenge_type: 'article').select { |x| x.available? }

    ## fetch current active upcoming challenge
    current_challenge = challenges.current_active.where.not(id: submitted_challenge_ids).where.not(challenge_type: ['signup', 'connect', 'article']).select { |x| x.available? && (x.start.strftime('%H:%M:%S') > DateTime.now.strftime('%H:%M:%S')) }.sort_by{ |x| x.start.strftime('%H:%M:%S') }.first

    ## fetch current active upcoming reward
    claimed_reward_ids = @campaign.participant_actions.where(participant_id: current_participant.id, actionable_type: "Reward").pluck(:actionable_id).uniq
    current_reward_hash = rewards.current_active.active.where.not(id: claimed_reward_ids).select { |x| x.available? }.first.as_json(type: 'one')

    current_reward = current_reward_hash.present? ? current_reward_hash.merge!({ title: current_reward_hash['name']}) : {}

    render_success 200, true, 'Challenges fetched successfully.', {
                                        featured_challenges: featured_challenges.as_json(type: 'list'),
                                        current_challenge: current_challenge.present? ? current_challenge.as_json(type: 'one') : {},
                                        current_reward: current_reward.present? ? current_reward : {}
                                }
  end


end
