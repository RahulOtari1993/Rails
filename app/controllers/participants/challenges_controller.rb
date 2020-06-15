class Participants::ChallengesController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_challenge

  def details
    @challenge = @campaign.challenges.where(id: params[:id]).first
  end

  def challenge_submission
    if current_participant.present?
      unless @challenge.blank?

        @submission = Submission.where(campaign_id: @campaign.id, participant_id: current_participant.id, challenge_id: @challenge.id).first_or_initialize
        if @submission.new_record?
          @submission.user_agent = request.user_agent
          @submission.ip_address = request.ip
          @submission.save
          render json: { status: 200, message: "Your points have been rewarded successfully in your account." }
        else
          if @challenge.challenge_type == "video"
            action_type = "watch_video"
            title = "Watch a video again"
            participant_action = ParticipantAction.new( participant_id: @submission.participant_id, points: @challenge.points, action_type: action_type, title: title, details: @challenge.caption, actionable_id: @challenge.id, actionable_type: @challenge.class.name, user_agent: request.user_agent, ip_address: request.ip)
            participant_action.save
          end
          render json: { status: 200, message: "You have already watched this video earlier." }
        end
      else
        render json: { status: 300, message: "Something is went wrong. Please try again later .." }
      end
    else
      render json: { status: 400, message: "Your session has been expired. Please login back again." }
    end
  end

  private

  def set_challenge
    @challenge = Challenge.where(id: params[:id]).first if params[:id].present?
  end
end
