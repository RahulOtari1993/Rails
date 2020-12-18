class Participants::ChallengesController < ApplicationController

  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  def fetch_media_posts
    network = @campaign.networks.current_active.where(platform: @challenge.parameters).first
    posts = network.network_page_posts.order(created_time: :desc).pluck(:id)
    @posts_attachments = NetworkPagePostAttachment.where(network_page_post_id: posts).order(created_at: :desc).order(created_at: :desc).page(params[:page]).per(4)
  end

  ## Fetch Details of Challenge
  def details
    if @campaign.present? && @campaign.white_branding
      @conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      @conf = GlobalConfiguration.first
    end

    # TODO refactor into handler class for maintainability with multiple challenges
    if ['referral','share'].include?(@challenge.challenge_type)
      @share_urls = ShareService.new.get_share_urls @challenge, current_participant, request
      @generic_url = @share_urls[:generic]
      @facebook_url = @share_urls[:facebook]
      if @challenge.use_short_url
        @shortened_urls = ShareService.new.get_shortened_share_urls @share_urls, @campaign, current_participant, request

        if !@shortened_urls.empty?
          if @shortened_urls[:generic]
            @generic_url = @shortened_urls[:generic]
          end
          if @shortened_urls[:facebook]
            @facebook_url = @shortened_urls[:facebook]
          end
        end
      end
    end

    @challenge_activity = @campaign.participant_actions.where(participant_id: current_participant.id, actionable_id: @challenge.id, actionable_type: "Challenge").first
    @reward = Reward.find(params[:reward_id]) unless params[:reward_id].blank?
    @questions = @challenge.questions.order(sequence: :asc).includes(:participant_answers)
  end

  ## Submit Challenges
  def submission

    # respond_to do |format|
    #   @response = {success: true,
    #                message: "You have completed this challenge successfully." }
    #   format.json { render json: @response }
    #   format.js { render layout: false }
    # end

    if @challenge.present?
      @submission = Submission.where(campaign_id: @challenge.campaign_id, participant_id: current_participant.id,
                                     challenge_id: @challenge.id).first_or_initialize

      if @submission.new_record?
        @submission.user_agent = request.user_agent
        @submission.ip_address = request.ip

        ## Save Onboarding/Extended Profile Question Answers
        if @challenge.challenge_type == 'collect' && @challenge.parameters == 'profile' && params[:questions].present?

          participant_profile_params = params[:participant].present? ? participant_params.merge!(onboarding_question_params) : onboarding_question_params
          unless current_participant.update(participant_profile_params)
            respond_to do |format|
              @response = {success: false, message: 'Something went wrong, Please try again.'}
              format.json { render json: @response }
              format.js { render layout: false }
            end
          end
        end

        if @submission.save
            ## create history for visiting challenge social feed posts by participant
            if @challenge.challenge_type == 'engage' && @challenge.parameters == 'facebook'
               post_visit = @challenge.social_challenge_post_visits.where(participant_id: current_participant.id,
                                        network_page_post_attachment_id: params[:post_attachment_id],
                                        points: @challenge.post_view_points.to_i).first_or_initialize
               post_visit.save
            end

          participant_action false
        else
          respond_to do |format|
            @response = {success: false, message: 'Challenge submission failed, Please try again.'}
            format.json { render json: @response }
            format.js { render layout: false }
          end
        end
      else
        if @challenge.challenge_type == 'engage' && @challenge.parameters == 'facebook'
           ## create history for visiting challenge social feed posts by participant
           post_visit = @challenge.social_challenge_post_visits.where(participant_id: current_participant.id,
                                     network_page_post_attachment_id: params[:post_attachment_id],
                                     points: @challenge.post_view_points.to_i).first_or_initialize
           post_visit.save


           ## update participant points for visiting other posts of same challenge
           challenge_points = @challenge.post_view_points.to_i
           points = current_participant.points.to_i + challenge_points
           unused_points = current_participant.unused_points.to_i + challenge_points
           ## Submitted Challenges Counter Changes
           completed_challenges = current_participant.completed_challenges.to_i + 1
           current_participant.points = points
           current_participant.unused_points = unused_points
           current_participant.completed_challenges = completed_challenges
           current_participant.save(validate: false)
        end
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

  ## Submit Quiz Challenge
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
        participant_action = ParticipantAction.new(participant_id: current_participant.id, points: 0,
                                                   action_type: 'quiz', title: 'Submitted Quiz', details: @challenge.caption,
                                                   actionable_id: @challenge.id, actionable_type: @challenge.class.name,
                                                   user_agent: request.user_agent, ip_address: request.ip,
                                                   campaign_id: @challenge.campaign_id, ahoy_visit_id: current_visit.id)
        participant_action.save!

        respond_to do |format|
          @response = {success: false, message: @challenge.failed_message}
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

  # Submit Survey Challenge
  def survey_submission
    if @challenge.present?
      ## Build Survey Answer Fields
      quiz_answer_records = build_survey_params
      quiz_answer_records.each do |record|
        participant_answer = ParticipantAnswer.new(record)
        participant_answer.save
      end

      @response = send(:submission)
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
          if question[:attribute_name] == 'birth_date' && question[:answer].present?
            birthdate = question[:answer]
            question[:answer] = convert_date_format(question[:answer])
          end
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

  ## Manage & Build Quiz Answer Params
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
      elsif (question.answer_type == "radio_button" || question.answer_type == "image_radio_button") && participant_answer_hash[:question_option_id].present?
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

  ## Manage & Build Survey Answer Params
  def build_survey_params
    participant_answer_params = []
    params[:questions].each do |key, answer_hash|
      question = Question.find(answer_hash[:question_id].to_i)
      temp_hash = answer_hash.as_json

      if question.present? && (question.answer_type == "string" || question.answer_type == "text_area" ||
          question.answer_type == "date" || question.answer_type == "time" || question.answer_type == "date_time" ||
          question.answer_type == "number" || question.answer_type == "decimal")

        temp_hash.merge!(campaign_id: @campaign.id, participant_id: current_participant.id)
        temp_hash = ActiveSupport::HashWithIndifferentAccess.new(temp_hash)
        participant_answer_params << temp_hash
      elsif question.present? && answer_hash[:answer].present? &&
          (question.answer_type == "radio_button" || question.answer_type == "check_box" ||
              question.answer_type == "dropdown" || question.answer_type == "boolean" ||
              question.answer_type == "image_radio_button" || question.answer_type == "image_check_box")

        answer_hash[:answer].each do |option_id|
          dup_hash = temp_hash.clone
          dup_hash[:question_option_id] = option_id
          dup_hash.merge!(campaign_id: @campaign.id, participant_id: current_participant.id, answer: nil)
          dup_hash = ActiveSupport::HashWithIndifferentAccess.new(dup_hash)
          participant_answer_params << dup_hash
        end
      end
    end

    participant_answer_params
  end

  ## Manage & Build Participant Params
  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :avatar)
  end

  def convert_date_format(date_details)
    existing_date = date_details.split('/')
    "#{existing_date[1]}/#{existing_date[0]}/#{existing_date[2]}"
  end

  private

  ## Set Challenge
  def set_challenge
    @challenge = Challenge.where(id: params[:id]).first rescue nil
  end

  ## Create Participant Action Entry
  def participant_action re_submission
    # challenge_points = (re_submission ? 0 : ((@challenge.challenge_type == 'engage' && @challenge.parameters == 'facebook') ? @challenge.post_view_points.to_i : @challenge.points.to_i))
    challenge_points = ((@challenge.challenge_type == 'engage' && @challenge.parameters == 'facebook') ? @challenge.post_view_points.to_i :  (re_submission ? 0 : @challenge.points.to_i))

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
    elsif @challenge.challenge_type == 'engage' && @challenge.parameters == 'facebook'
      action_type = 'feed'
      title = re_submission ? 'Again Visited Social(facebook) feed' : 'Visited Social(facebook) feed'
    elsif @challenge.challenge_type == 'referral'
    elsif @challenge.challenge_type == 'signup'
    end

    begin
      participant_action = ParticipantAction.new(participant_id: @submission.participant_id, points: challenge_points,
                                                 action_type: action_type, title: title, details: @challenge.caption,
                                                 actionable_id: @challenge.id, actionable_type: @challenge.class.name,
                                                 user_agent: request.user_agent, ip_address: request.ip,
                                                 campaign_id: @challenge.campaign_id, ahoy_visit_id: current_visit.id)
      participant_action.save!

      ## Claim the reward after successful submission of challenge for reward type
      if @challenge.reward_type == 'prize' && !re_submission
        reward_service = RewardsService.new(current_participant.id, @challenge.reward_id, request, current_visit)
        @response = reward_service.process
      end

      respond_to do |format|
        @response = {success: true,
                     message: ((@challenge.challenge_type == 'collect' && @challenge.parameters == 'quiz') ? @challenge.success_message : "Congratulations, You have completed this challenge successfully."), user_points: current_participant.reload.unused_points.to_i}
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
