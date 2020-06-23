module ParticipantsHelper
  ## Display Challenges of a Campaign
  def all_challenges_filter
    @campaign.challenges.pluck(:name, :id)
  end
end
