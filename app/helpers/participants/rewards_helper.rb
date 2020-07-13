module Participants::RewardsHelper

  def get_reward_challenge(reward_id)
    challenge = @campaign.challenges.where(reward_id: reward_id).first
    challenge.try(:id)
  end

  def coupon_claimed(reward)
    if current_participant.present?
      reward.reward_participants.pluck(:participant_id).include?(current_participant.id)
    else
      false
    end
  end

  def get_coupon_code(reward)
    reward_participant = reward.reward_participants.first
    coupon_code = reward.coupons.where(reward_participant_id: reward_participant.id).first.try(:code)
    coupon_code
  end

  ## Calculate Current Logged in User's Sweepstake Entries
  def fetch_sweepstake_entries(reward)
    total_earned_points = current_participant.participant_actions.where(created_at: reward.start..reward.finish).pluck(:points).compact.sum
    no_of_entries = (total_earned_points / reward.sweepstake_entry.to_i)

    no_of_entries
  end
end
