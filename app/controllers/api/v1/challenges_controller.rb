class Api::V1::ChallengesController < Api::V1::BaseController
  skip_before_action :authenticate_participant!, :only => :connect_challenges
  before_action :set_current_participant, only: [:index, :show], if: -> { @campaign.present? }

  ## Fetch All Challenges of a Campaign
  def index
    challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? }
    challenges = Kaminari.paginate_array(challenges).page(page).per(per_page)
    set_pagination_header(challenges)

    challenges_ary = []
    challenges.each do |obj|
      obj_hash = obj.as_json(type: 'one')
      obj_hash = obj_hash.merge!({ is_completed: obj.is_completed?(current_participant.id), social_platform_connected: obj.is_social_platform_connected?(current_participant.id) })
      challenges_ary << obj_hash
    end

    render_success 200, true, 'Challenges fetched successfully.', { challenges: challenges_ary, total_gobucks:  current_participant.unused_points.to_i, challenges_completed: current_participant.submissions.length }
  end

  ## Fetch Particular Challenge Details
  def show
    challenge = @campaign.challenges.where(id: params[:id]).first
    challenge_hash = challenge.as_json(type: 'one')
    challenge_obj = challenge_hash.merge!({ is_completed: challenge.is_completed?(current_participant.id), social_platform_connected: challenge.is_social_platform_connected?(current_participant.id) })

    render_success 200, true, 'Challenge details fetched successfully.', challenge_obj
  end

  ## Fetch Active Connect Challenges (Facebook, Google & Twitter)
  def connect_challenges
    challenges = @campaign.challenges.current_active
                     .where(challenge_type: ['signup', 'connect'], parameters: ['facebook', 'google', 'twitter'])

    render_success 200, true, 'Connect Challenge details fetched successfully.', challenges.as_json(type: 'list')
  end

  ## Submit Challenge
  def submit
    challenge = Challenge.where(id: params[:id]).first

    if challenge.present?
      submission = Submission.where(campaign_id: challenge.campaign_id, participant_id: current_participant.id,
                                    challenge_id: challenge.id).first_or_initialize

      if submission.new_record?
        ## Save Onboarding/Extended Profile Question Answers
        if challenge.challenge_type == 'collect' && challenge.parameters == 'profile' && params[:questions].present?
          current_participant.update!(extended_profile_question_params)
        end

        if submission.save
          response = participant_action(challenge, submission, false)
          if response[:status]
            render_success 200, true, response[:message], {}
          else
            render_success 200, true, response[:message], {}
          end
        else
          return_error 500, false, 'Challenge submission failed, Please try again.', {}
        end
      else
        response = participant_action(challenge, submission, true)
        if response[:status]
          render_success 200, true, response[:message], {}
        else
          render_success 200, true, response[:message], {}
        end
      end
    else
      return_error 500, false, 'Challenge not found, Please contact administrator.', {}
    end
  end

  ## Fetch Completed Challenges of a Participant
  def completed
    challenge_ids = @campaign.submissions.where(participant_id: current_participant.id).page(page).per(per_page).pluck(:challenge_id)
    challenges = @campaign.challenges.where(id: challenge_ids)

    render_success 200, true, 'Completed challenges fetched successfully.', challenges.as_json(type: 'list')
  end

  ## Fetch Onboarding Questions , options to show in  onbording form
  def onboarding_questions
    onboarding_challenge = @campaign.challenges.current_active.where(challenge_type: 'collect', parameters: 'profile').first
    if onboarding_challenge.present?

      response = []
      questions = onboarding_challenge.questions.order(:sequence)
      questions.each do |question|
        question_options = []

        question_options = question.question_options.order(:sequence).map { |x| x.as_json }
        question_hash = question.as_json
        question_obj = question_hash.merge!({
                                     is_custom: question.profile_attribute.is_custom,
                                     attribute_name: question.profile_attribute.attribute_name,
                                     question_options: question_options
                                  })

        response << question_obj
      end

      render_success 200, true, 'Onboarding Questions fetched successfully.', response
    else
      render_success 404, false, 'No Onboarding questions found.', {}
    end
  end


  private

  ## Create Participant Action Entry
  def participant_action(challenge, submission, re_submission)
    challenge_points = re_submission ? challenge.points : 0
    if challenge.challenge_type == 'link'
      action_type = 'visit_url'
      title = re_submission ? 'Again Visited a url' : "Visited a url"
    elsif challenge.challenge_type == 'video'
      action_type = 'watch_video'
      title = re_submission ? 'Again Watched a Video' : 'Watched a Video'
    elsif challenge.challenge_type == 'article'
      action_type = 'read_article'
      title = re_submission ? 'Again read an article' : 'Read an article'
    end

    participant_action = ParticipantAction.new(participant_id: submission.participant_id, points: challenge_points,
                                               action_type: action_type, title: title, details: challenge.caption,
                                               actionable_id: challenge.id, actionable_type: challenge.class.name,
                                               user_agent: request.user_agent, ip_address: request.ip,
                                               campaign_id: challenge.campaign_id)
    if participant_action.save
      ## Claim the reward after successful submission of challenge for reward type
      if challenge.reward_type == 'prize' && !re_submission
        reward_service = RewardsService.new(current_participant.id, challenge.reward_id, request)
        reward_response = reward_service.process
        response = {success: true, message: "Challenge submitted successfully and #{reward_response[:message]}"}
      else
        response = {success: true, message: 'Challenge submitted successfully.'}
      end
    else
      response = {success: false, message: 'Challenge submitted successfully, User Audit Entry failed.'}
    end

    response
  end

  ## Manage & Build Extended Profile Question Params
  def extended_profile_question_params
    birthdate = ''
    age = 0

    profile_params = {participant_profiles_attributes: []}
    params[:questions].each do |question|
      if question[:is_custom] == true
        if question[:answer_ids].present?
          binding.pry
            question[:answer_ids].each do |opt|
              profile_params[:participant_profiles_attributes].push({
                                                                        profile_attribute_id: question[:profile_attribute_id],
                                                                        value: opt
                                                                    })
            end

        elsif question[:answer_text].present?
            profile_params[:participant_profiles_attributes].push({
                                                                      profile_attribute_id: question[:profile_attribute_id],
                                                                      value: question[:answer_text]
                                                                  })
        end
      else
        if question[:answer_ids].present?
            question[:answer_ids].each do |opt|
              profile_params[question[:attribute_name]] = opt
            end
        elsif question[:answer_text].present?
            profile_params[question[:attribute_name]] = question[:answer_text]
            birthdate = question[:answer_text] if question[:attribute_name] == 'birth_date' && question[:answer_text].present?
            age = question[:answer_text].to_i if question[:attribute_name] == 'age' && question[:answer_text].present?
        end
      end
    end

    ## Age Calculation
    attributes = params['questions'].map { |x| x[:attribute_name] }
    if (!attributes.include?('age') || age == '' || age == 0) && (attributes.include?('birth_date') && birthdate != '')
      profile_params['age'] = Participant.calculate_age(birthdate)
    end

    profile_params
  end
end
