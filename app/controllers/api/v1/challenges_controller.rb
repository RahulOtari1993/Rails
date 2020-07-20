class Api::V1::ChallengesController < Api::V1::BaseController
  before_action :set_current_participant, only: [:index, :show], if: -> { @campaign.present? }

  ## Fetch All Challenges of a Campaign
  def index
    challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select { |x| x.available? }
    challenges = Kaminari.paginate_array(challenges).page(page).per(per_page)
    set_pagination_header(challenges)

    render_success 200, true, 'Challenges fetched successfully.', challenges.as_json(type: 'list')
  end

  ## Fetch Particular Challenge Details
  def show
    challenge = @campaign.challenges.where(id: params[:id])
    render_success 200, true, 'Challenge details fetched successfully.', challenge.as_json(type: 'one')
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
    params[:questions].each do |key, question|
      if question[:is_custom] == 'true'
        if question[:answer].instance_of? Array
          question[:answer].each do |opt|
            profile_params[:participant_profiles_attributes].push({
                                                                      profile_attribute_id: question[:profile_attribute_id],
                                                                      value: opt
                                                                  })
          end
        else
          profile_params[:participant_profiles_attributes].push({
                                                                    profile_attribute_id: question[:profile_attribute_id],
                                                                    value: question[:answer]
                                                                })
        end
      else
        if question[:answer].instance_of? Array
          question[:answer].each do |opt|
            profile_params[question[:attribute_name]] = opt
          end
        else
          profile_params[question[:attribute_name]] = question[:answer]
          birthdate = question[:answer] if question[:attribute_name] == 'birth_date' && question[:answer].present?
          age = question[:answer].to_i if question[:attribute_name] == 'age' && question[:answer].present?
        end
      end
    end

    ## Age Calculation
    attributes = params['questions'].values.map { |x| x[:attribute_name] }
    if (!attributes.include?('age') || age == '' || age == 0) && (attributes.include?('birth_date') && birthdate != '')
      profile_params['age'] = Participant.calculate_age(birthdate)
    end

    profile_params
  end
end
