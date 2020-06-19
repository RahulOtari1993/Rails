class RewardsService
  def initialize(participant_id)
    @participant = Participant.where(id: participant_id).first
    @campaign = @participant.present? ? @participant.campaign : nil
  end

  ## Process Rewards for Participant Eligibility
  def process
    if @participant.present? && @campaign.present?
      Rails.logger.info "============== IN PROCESS START =============="
      Rails.logger.info "============== @participant_id #{@participant.inspect} =============="
      Rails.logger.info "============== @campaign #{@campaign.inspect} =============="
      Rails.logger.info "============== IN PROCESS END =============="

      rewards = @campaign.rewards.current_active
      rewards.each do |reward|
        if reward.selection == 'milestone'
          ## Check for Reward Availability
          if reward.available_quantity > 0
            ## Check Whether Participant Claimed Reward Previously or Not
            reward_participant = reward.reward_participants.where(participant_id: @participant.id).first_or_initialize
            if reward_participant.new_record?
              is_eligible = reward.eligible? @participant
              Rails.logger.info "============== is_eligible #{is_eligible.inspect} =============="

              if is_eligible
                ## Claimed Rewards - NOT
                ## Assign Coupon
                ## Shot an Email

                reward_participant.save

                # Grab a Coupon for Participant & Assign it
                coupon = reward.coupons.where(reward_participant_id: nil).first
                if coupon.present?

                  action_type = 'claim_reward'


                  if coupon.update(reward_participant_id: reward_participant.id)
                    begin
                      participant_action = ParticipantAction.new(participant_id: @participant.id, points: reward.points,
                                                                 action_type: action_type, title: 'Won a Milestone Reward',
                                                                 details: reward.name, actionable_id: reward.id, actionable_type: reward.class.name,
                                                                 user_agent: request.user_agent, ip_address: request.ip)
                      participant_action.save!

                      RewardMailer.cash_in_reward(reward, @participant, coupon).deliver
                    rescue Exception => e
                      Rails.logger.info "ERROR: Milestone Reward Completion Participant Action Entry Failed --> #{e.message}"
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end