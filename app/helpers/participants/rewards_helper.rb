module Participants::RewardsHelper

  def get_reward_challenge(reward_id)
    challenge = @campaign.challenges.where(reward_id: reward_id).first
    challenge.try(:id)
  end

  def coupons_available(reward)
    reward.coupons.present?
  end

  def coupon_claimed(reward)
    if current_participant.present?
      reward.reward_participants.pluck(:participant_id).include?(current_participant.id)
    else
      false
    end
  end
end
