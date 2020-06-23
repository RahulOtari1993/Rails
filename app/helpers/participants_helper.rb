module ParticipantsHelper
  ## Display SignUp / SignIn with Google Button Based on Configured Challenge
  def all_challenges_filter
    @campaign.challenges.pluck(:name, :id)
  end
end
