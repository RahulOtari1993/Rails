class Participants::ChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  ## Fetch Details of Challenge
  def details
    if @campaign.present? && @campaign.white_branding
      @conf = CampaignConfig.where(campaign_id: @campaign.id).first
    else
      @conf = GlobalConfiguration.first
    end
    # TODO refactor into handler class for maintainability with multiple challenges
    if @challenge.challenge_type == 'referral'
      if current_participant.referral_codes.for_challenge(@challenge).empty?
        @referral_code = ReferralCode.create(challenge_id: @challenge.id, participant_id: current_participant.id)
      else
        @referral_code = current_participant.referral_codes.for_challenge(@challenge).first
      end
      @referral_link = "#{request.protocol}#{request.host}?refid=#{@referral_code.code}"
    end
    @reward = Reward.find(params[:reward_id]) unless params[:reward_id].blank?
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
    elsif @challenge.challenge_type == 'referral'
    elsif @challenge.challenge_type == 'collect'
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
        @response = {success: true, message: 'Challenge submitted successfully.'}
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
