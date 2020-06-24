module EndUserHelper
  ## Display SignUp / SignIn with Google Button Based on Configured Challenge
  def display_google_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'google').first
  end

  ## Display SignUp / SignIn with Facebook Button Based on Configured Challenge
  def display_facebook_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'facebook').first
  end

  ## Display SignUp / SignIn with Email Button Based on Configured Challenge
  def display_email_button
    @campaign.challenges.current_active.where(challenge_type: 'signup', parameters: 'email').first
  end

  ## Check whether Onboarding Challenge is Available & Active
  def check_onboarding_challege
    @campaign.challenges.current_active.where(challenge_type: 'collect', parameters: 'profile')
  end

  ## Check whether Onboarding Challenge is Submitted Previously
  def check_onboarding_challege_submission challenge
    Submission.where(campaign_id: challenge.campaign_id, participant_id: current_participant.id,
                                  challenge_id: challenge.id).present?
  end

  ## Add Required Class to Answer Fields
  def answer_required(str, is_required)
    is_required ? str + '-required' : ''
  end
end
