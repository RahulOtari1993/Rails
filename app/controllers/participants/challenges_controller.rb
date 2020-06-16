class Participants::ChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  ## Fetch Details of Challenge
  def details
  end

  ## Submit Challenges
  def submission
    if @challenge.present?
      @submission = Submission.where(campaign_id: @challenge.campaign_id, participant_id: current_participant.id,
                                     challenge_id: @challenge.id).first_or_initialize

      if @submission.new_record?
        @submission.user_agent = request.user_agent
        @submission.ip_address = request.ip
        if @submission.save
          participant_action false
        else
          render json: {success: false, message: 'Challenge submission failed, Please try again.'}
        end
      else
        participant_action true
      end
    else
      render json: {success: false, message: 'Challenge not found, Please contact administrator.'}
    end
  end

  private

  def set_challenge
    @challenge = Challenge.where(id: params[:id]).first rescue nil
  end

  ## Create Participant Action Entry
  def participant_action re_submission
    if @challenge.challenge_type == 'link'
      action_type = 'visit_url'
      unless re_submission
        title = "Watched a Video"
      else
        title = "Again Watched a Video"
      end
    elsif @challenge.challenge_type == 'video'
      action_type = 'watch_video'
      unless re_submission
        title = "Watched a Video"
      else
        title = "Again Watched a Video"
      end
    elsif @challenge.challenge_type == 'article'
    elsif @challenge.challenge_type == 'referral'
    elsif @challenge.challenge_type == 'collect'
    elsif @challenge.challenge_type == 'signup'
    end

    begin
      participant_action = ParticipantAction.new(participant_id: @submission.participant_id, points: @challenge.points,
                                                 action_type: action_type, title: title, details: @challenge.caption,
                                                 actionable_id: @challenge.id, actionable_type: @challenge.class.name,
                                                 user_agent: request.user_agent, ip_address: request.ip)
      participant_action.save!

      render json: {success: true, message: 'Challenge submitted successfully.'}
    rescue Exception => e
      Rails.logger.info "Participant Action Entry Failed --> #{e.message}"
      render json: {success: false, message: 'Challenge submitted successfully, User Audit Entry failed.'}
    end
  end
end
