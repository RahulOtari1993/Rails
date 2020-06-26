class Participants::ChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  ## Fetch Details of Challenge
  def details
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
          end

        end
      end

      profile_params
    end

  private

    ## Set Challenge
    def set_challenge
      @challenge = Challenge.where(id: params[:id]).first rescue nil
    end

    ## Create Participant Action Entry
    def participant_action re_submission
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
        participant_action = ParticipantAction.new(participant_id: @submission.participant_id, points: @challenge.points,
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
