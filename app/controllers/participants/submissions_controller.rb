class Participants::SubmissionsController < ApplicationController
  layout 'non_login_submission'

  ## Used for Non Logged In Users to Submit Challenges
  def load_details
    if params[:type] == 'challenge' && params[:identifier].present?
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials[Rails.env.to_sym][:encryption_key])

      ## Encrypt in URI Format & Pass in URL
      # encrypted_data = crypt.encrypt_and_sign('C9E392FF81C29b00130abbfb')
      # encrypted_data = URI.encode_www_form_component(encrypted_data)

      identifier = crypt.decrypt_and_verify(params[:identifier])
      participant_id = identifier[0, 12]
      challenge_id = identifier[12, 24]

      @participant = Participant.where(p_id: participant_id.to_s).first
      @identifier = params[:identifier]
      @challenge = Challenge.where(identifier: challenge_id.to_s).first
      @challenge_activity = @campaign.participant_actions
                                .where(participant_id: @participant.id, actionable_id: @challenge.id, actionable_type: "Challenge").first
      @questions = @challenge.questions.order(sequence: :asc)
    end
  end

  ## Submit Challenges Without Login
  def challenge
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials[Rails.env.to_sym][:encryption_key])
    identifier = crypt.decrypt_and_verify(params[:identifier])
    participant_id = identifier[0, 12]
    challenge_id = identifier[12, 24]
    status = true

    @participant = Participant.where(p_id: participant_id.to_s).first
    @challenge = Challenge.where(identifier: challenge_id.to_s).first

    if @challenge.present? && @participant.present?
      if @challenge.challenge_type == 'collect' && @challenge.parameters == 'quiz'
        quiz_submission

        ## Check Eligible for Challenge submission
        correct_answer_count = @challenge.participant_answers.correct.count
        unless correct_answer_count >= @challenge.correct_answer_count
          status = false
        end
      elsif @challenge.challenge_type == 'collect' && @challenge.parameters == 'survey'
        survey_submission
      end

      if status
        @submission = Submission.where(campaign_id: @challenge.campaign_id, participant_id: @participant.id,
                                       challenge_id: @challenge.id).first_or_initialize
        if @submission.new_record?
          @submission.user_agent = request.user_agent
          @submission.ip_address = request.ip

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
          @response = {success: false, message: @challenge.failed_message}
          format.js { render layout: false }
        end
      end
    else
      respond_to do |format|
        @response = {success: false, message: 'Challenge not found, Please contact administrator.'}
        format.json { render json: @response }
        format.js { render layout: false }
      end
    end
  end

  protected

  ## Save Quiz Challenge Answers
  def quiz_submission
    quiz_answer_records = build_quiz_params
    quiz_answer_records.each do |record|
      begin
        participant_answer = ParticipantAnswer.new(record)
        participant_answer.save
      rescue Exception => e
        Rails.logger.info "Non Login Quiz Submission Failed --> #{e.message}"
      end
    end
  end

  ## Manage & Build Extended Challenge Question Params
  def build_quiz_params
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
        temp_hash.merge!(campaign_id: @campaign.id, participant_id: @participant.id, result: result)
        temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
        participant_answer_params << temp_hash
      elsif question.answer_type == "radio_button" && participant_answer_hash[:question_option_id].present?
        ## build hashes having multiple answers for radio buttons & checkboxes
        participant_answer_hash[:question_option_id].each do |option_id|
          temp_hash = participant_answer_hash.as_json
          temp_hash[:question_option_id] = option_id
          result = (temp_hash[:question_option_id].to_i == option.id)
          temp_hash.merge!(campaign_id: @campaign.id, participant_id: @participant.id, result: result)
          temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
          participant_answer_params << temp_hash
        end
      end
    end
    participant_answer_params
  end

  ## Save Survey Challenge Answers
  def survey_submission
    answer_records = build_survey_params
    answer_records.each do |record|
      begin
        participant_answer = ParticipantAnswer.new(record)
        participant_answer.save
      rescue Exception => e
        Rails.logger.info "Non Login Survey Submission Failed --> #{e.message}"
      end
    end
  end

  ## Manage & Build Survey Answer Params
  def build_survey_params
    participant_answer_params = []
    params[:questions].each do |key, answer_hash|
      question = Question.find(answer_hash[:question_id].to_i)
      temp_hash = answer_hash.as_json

      if question.present? && (question.answer_type == "string" || question.answer_type == "text_area" ||
          question.answer_type == "date" || question.answer_type == "time" || question.answer_type == "date_time" ||
          question.answer_type == "number" || question.answer_type == "decimal")

        temp_hash.merge!(campaign_id: @campaign.id, participant_id: @participant.id)
        temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
        participant_answer_params << temp_hash
      elsif question.present? && answer_hash[:answer].present? &&
          (question.answer_type == "radio_button" || question.answer_type == "check_box" ||
              question.answer_type == "dropdown" || question.answer_type == "boolean")

        answer_hash[:answer].each do |option_id|
          dup_hash = temp_hash.clone
          dup_hash[:question_option_id] = option_id
          dup_hash.merge!(campaign_id: @campaign.id, participant_id: @participant.id, answer: nil)
          dup_hash = ActiveSupport::HashWithIndifferentAccess.new(dup_hash)
          participant_answer_params << dup_hash
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
        reward_service = RewardsService.new(@participant.id, @challenge.reward_id, request)
        @response = reward_service.process
      end

      respond_to do |format|
        @response = {success: true,
                     message: ((@challenge.challenge_type == 'collect' && @challenge.parameters == 'quiz') ? @challenge.success_message : "Congratulations, You have completed this challenge successfully.")}
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
