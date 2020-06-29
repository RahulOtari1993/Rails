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

  ## Fetch Placeholder Details
  def fetch_placeholder_details(question, field_type)
    if question.placeholder.present?
      question.placeholder
    else
      case field_type
        when 'text_area' then
          'Add details here'
        when 'date' then
          'Select date'
        when 'time' then
          'Select time'
        when 'date_time' then
          'Select date and time'
        when 'dropdown' then
          'Select Answer'
        else
          'Answer here'
      end
    end
  end

  ## Fetch Header Text Based on Template Configuration
  def list_header_text
    if @template.header_text.present?
      @template.header_text
    else
      'The Official Loyalty Program of Buckeye Nation'
    end
  end

  ## Fetch Header Text Based on Template Configuration
  def list_header_details
    if @template.header_description.present?
      @template.header_description
    else
      'Take your Buckeye Pride to the next level with Buckeye Nation Rewards. The only way to get insider access and perks for your pride.'
    end
  end

  ## Fetch Header Hero Image Background Logo Based on Template Configuration
  def list_header_bg_logo
    if @template.header_logo.present? && @template.header_logo.url.present?
      @template.header_logo.url
    else
      asset_path 'end-user/banner_bg.png'
    end
  end
end
