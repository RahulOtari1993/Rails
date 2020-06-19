class Participants::RewardsController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  before_action :set_reward

  ## Fetch Details of reward
  def details

  end

  ## Claim Reward
  def claim
    if @reward.present? && (@reward.limit.to_i > @reward.claims)
      @reward_participant = @reward.reward_participants.where(participant_id: current_participant.id).first_or_initialize

      if @reward_participant.new_record?
         @reward_participant.save

        @coupon = @reward.coupons.where(reward_participant_id: nil).first
        if @coupon.present?
          @coupon.update(reward_participant_id: @reward_participant.id)
          participant_action
        else
          respond_to do |format|
            @response = {success: false, message: 'Reward claim failed, Please try again.'}
            format.json { render json: @response }
            format.js { render layout: false }
          end
        end
      else
        respond_to do |format|
          @response = {success: false, message: 'You have already claimed this reward earlier.'}
          format.json { render json: @response }
          format.js { render layout: false }
        end
      end
    else
      respond_to do |format|
        @response = {success: false, message: 'Reward not found, Please contact administrator.'}
        format.json { render json: @response }
        format.js { render layout: false }
      end
    end
  end


  private
    ## Set Reward
    def set_reward
      @reward = Reward.where(id: params[:id]).first rescue nil
    end

    ## Create Participant Action Entry
    def participant_action
      if @reward.selection == 'redeem'
        action_type = 'claim_reward'
        title = "Claimed a Cash In Reward"
      elsif @reward.selection == 'instant'
      end

      begin
        participant_action = ParticipantAction.new(participant_id: current_participant.id, points: @reward.points,
                                                   action_type: action_type, title: title, details: @reward.name,
                                                   actionable_id: @reward.id, actionable_type: @reward.class.name,
                                                   user_agent: request.user_agent, ip_address: request.ip)
        participant_action.save!

        RewardMailer.cash_in_reward(@reward, current_participant, @coupon).deliver

        respond_to do |format|
          @response = {success: true, message: 'Reward claimed successfully.'}
          format.json { render json: @response }
          format.js { render layout: false }
        end
      rescue Exception => e
        Rails.logger.info "Participant Action Entry Failed --> #{e.message}"

        respond_to do |format|
          @response = {success: false, message: 'Reward claimed successfully, User Audit Entry failed.'}
          format.json { render json: @response }
          format.js { render layout: false }
        end
      end
    end
end
