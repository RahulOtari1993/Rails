module EndUserHelper
  ## Display SignUp / SignIn with Google Button Based on Configured Challenge
  def display_google_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'google').present?
  end

  ## Display SignUp / SignIn with Facebook Button Based on Configured Challenge
  def display_facebook_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'facebook').present?
  end

  ## Display SignUp / SignIn with Email Button Based on Configured Challenge
  def display_email_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'email').present?
  end
end
