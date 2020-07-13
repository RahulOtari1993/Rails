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

  ## Display Connect Twitter Button
  def fetch_twitter_challenge
    @campaign.challenges.current_active.where(challenge_type: 'connect', parameters: 'twitter').first
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

  ## Fetch Header Hero Image Background Based on Template Configuration
  def list_header_bg_image
    if @template.header_background_image.present? && @template.header_background_image.url.present?
      @template.header_background_image.url
    else
      asset_path 'end-user/banner_bg.png'
    end
  end

  ## Fetch Header Logo Image Based on Template Configuration
  def list_header_logo
    if @template.header_logo.present? && @template.header_logo.url.present?
      @template.header_logo.url
    else
      asset_path 'end-user/BNR-Logo-Horizontal-Color-Black.svg'
    end
  end

  ## Fetch correct option for the challenge question
  def get_correct_option_id(question)
    option_id = nil
    if question.answer_type == "string"
      option_id = question.question_options.first.id
    elsif question.answer_type == "radio_button"
      option_id = question.question_options.where(answer: "t").first.id
    end
    option_id
  end

  def fetch_question_answered_value(question, option_id = nil)
    if question.answer_type == "string"
      result = @challenge.participant_answers.where(participant_id: current_participant.id, question_id: question.id).first.answer rescue nil #Todo
    else
      selected_option_id = @challenge.participant_answers.where(participant_id: current_participant.id, question_id: question.id).first.question_option_id
      result = (option_id == selected_option_id)
    end
    result
  end
end
