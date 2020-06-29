module ParticipantsHelper
  ## Display Challenges of a Campaign
  def all_challenges_filter
    @campaign.challenges.pluck(:name, :id)
  end

  ## Display Rewards of a Campaign
  def all_rewards_filter
    @campaign.rewards.pluck(:name, :id)
  end

  ## Display % of Targeted Users
  def targeted_users_percentage
    total_participants = @challenge.completions
    targeted_participants = @challenge.targeted_participants
    percentage = (targeted_participants.count * 100 ) / total_participants.to_i

    percentage
  end
end
