module ParticipantsHelper
  ## Display Challenges of a Campaign
  def all_challenges_filter
    @campaign.challenges.pluck(:name, :id)
  end

  ## Display Rewards of a Campaign
  def all_rewards_filter
    @campaign.rewards.pluck(:name, :id)
  end
end
