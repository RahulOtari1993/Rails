class Participants::ChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  ## Fetch Details of Challenge
  def details
    @challenge_activity = @campaign.participant_actions.where(actionable_id: @challenge.id, actionable_type: "Challenge").first
    @reward = Reward.find(params[:reward_id]) unless params[:reward_id].blank?
    @questions = @challenge.questions.order(sequence: :asc).includes(:participant_answers)
  end

  ## Submit Challenges
  def submission
    if @challenge.present?
      @submission = Submission.where(campaign_id: @challenge.campaign_id, participant_id: current_participant.id,
                                     challenge_id: @challenge.id).first_or_initialize

      if @submission.new_record?
        @submission.user_agent = request.user_agent
        @submission.ip_address = request.ip

        ## Save Onboarding Profile Questions
        if @challenge.challenge_type == 'collect' && @challenge.parameters == 'profile' && params[:questions].present?
          unless current_participant.update(onboarding_question_params)
            respond_to do |format|
              @response = {success: false, message: 'Something went wrong, Please try again.'}
              format.json { render json: @response }
              format.js { render layout: false }
            end
          end
        end

        if @submission.save
          participant_action false
        else
          respond_to do |format|
            @response = {success: false, message: 'Challenge submission failed, Please try again.'}
            format.json { render json: @response }
            format.js { render layout: false }
          end
        end
      else
        participant_action true
      end
    else
      respond_to do |format|
        @response = {success: false, message: 'Challenge not found, Please contact administrator.'}
        format.json { render json: @response }
        format.js { render layout: false }
      end
    end
  end

  ## Submit Quiz and Survey Challenge
  def quiz_submission
    if @challenge.present?
      ## save challenge quiz answers submitted
      quiz_answer_records = challenge_quiz_params
      quiz_answer_records.each do |record|
        participant_answer = ParticipantAnswer.new(record)
        participant_answer.save
      end

      ## Check Eligible for Challenge submission
      correct_answer_count = @challenge.participant_answers.correct.count
      if correct_answer_count >= @challenge.correct_answer_count
        ## Challenge Submission code
        @response = send(:submission)
      else
        respond_to do |format|
          @response = {success: false, message: "Sorry, You're not eligible to earn points, Please contact administrator."}
          format.js { render layout: false }
        end
      end
    else
      respond_to do |format|
        @response = {success: false, message: 'Challenge not found, Please contact administrator.'}
        format.js { render layout: false }
      end
    end
  end

  protected

  ## Manage & Build Extended Profile Question Params
  def onboarding_question_params
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
      profile_params['age'] = calculate_age birthdate
    end

    profile_params
  end

  ## Age Calculation
  def calculate_age(birth_date)
    age = 0
    birth_year = Date.strptime(birth_date, '%m/%d/%Y').year rescue 0
    age = Time.zone.now.year - birth_year.to_i if birth_year.to_i > 0

    age
  end

  ## Manage & Build Extended Challenge Question Params
  def challenge_quiz_params
    participant_answer_params = []
    params[:questions].each do |key, participant_answer_hash|
      result = false
      question = Question.find(participant_answer_hash[:question_id].to_i)
      correct_option_id = participant_answer_hash.delete(:correct_option_id).to_i
      option = question.question_options.where(id: correct_option_id).first

      if question.answer_type == "string"
        ## build hashes having single answer
        temp_hash = participant_answer_hash.as_json
        result = (participant_answer_hash[:answer].strip.downcase == option.answer.downcase)
        temp_hash.merge!(campaign_id: @campaign.id, participant_id: current_participant.id, result: result)
        temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
        participant_answer_params << temp_hash
      elsif question.answer_type == "radio_button"
        ## build hashes having multiple answers for radio buttons & checkboxes
        participant_answer_hash[:question_option_id].each do |option_id|
          temp_hash = participant_answer_hash.as_json
          temp_hash[:question_option_id] = option_id
          result = (temp_hash[:question_option_id].to_i == option.id)
          temp_hash.merge!(campaign_id: @campaign.id, participant_id: current_participant.id, result: result)
          temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
          participant_answer_params << temp_hash
        end
      end
    end
    participant_answer_params
  end

  private

  ## Set Challenge
  def set_challenge
    @challenge = Challenge.where(id: params[:id]).first rescue nil
  end

  ## Create Participant Action Entry
  def participant_action re_submission
    challenge_points = re_submission ? @challenge.points : 0
    if @challenge.challenge_type == 'link'
      action_type = 'visit_url'
      title = re_submission ? 'Again Visited a url' : "Visited a url"
    elsif @challenge.challenge_type == 'video'
      action_type = 'watch_video'
      title = re_submission ? 'Again Watched a Video' : 'Watched a Video'
    elsif @challenge.challenge_type == 'article'
      action_type = 'read_article'
      title = re_submission ? 'Again read an article' : 'Read an article'
    elsif @challenge.challenge_type == 'collect' && @challenge.parameters == 'profile'
      title = 'Submitted Extended Profile Question'
    elsif @challenge.challenge_type == 'collect' && @challenge.parameters == 'quiz'
      action_type = 'quiz'
      title = 'Submitted Quiz'
    elsif @challenge.challenge_type == 'referral'
    elsif @challenge.challenge_type == 'signup'
    end

    begin
      participant_action = ParticipantAction.new(participant_id: @submission.participant_id, points: challenge_points,
                                                 action_type: action_type, title: title, details: @challenge.caption,
                                                 actionable_id: @challenge.id, actionable_type: @challenge.class.name,
                                                 user_agent: request.user_agent, ip_address: request.ip,
                                                 campaign_id: @challenge.campaign_id)
      participant_action.save!

      ## Claim the reward after successfull submission of challenge for reward type
      if @challenge.reward_type == 'prize' && !re_submission
        reward_service = RewardsService.new(current_participant.id, @challenge.reward_id, request)
        @response = reward_service.process
      end

      respond_to do |format|
        @response = {success: true, message: "Congratulations, You've completed this challenge successfully."}
        format.json { render json: @response }
        format.js { render layout: false }
      end
    rescue Exception => e
      Rails.logger.info "Participant Action Entry Failed --> #{e.message}"

      respond_to do |format|
        @response = {success: false, message: 'Challenge submitted successfully, User Audit Entry failed.'}
        format.json { render json: @response }
        format.js { render layout: false }
      end
    end
  end
end
