class RewardsService
  def initialize(participant_id, reward_id = nil, request = nil, visit = nil)
    @participant = Participant.where(id: participant_id).first
    @campaign = @participant.present? ? @participant.campaign : nil
    @reward = @campaign.rewards.where(id: reward_id).first rescue nil
    @request = request
    @visit = visit
  end

  ## Process Rewards for Participant Eligibility
  def process
    if @participant.present? && @campaign.present? && @reward.present?
      ## Check Whether Participant Claimed Reward Previously or Not
      reward_participant = @reward.reward_participants.where(participant_id: @participant.id).first_or_initialize

      if reward_participant.new_record?
        reward_participant.save

        ## Grab a Coupon for Participant & Assign it
        @coupon = @reward.coupons.where(reward_participant_id: nil).first
        @coupon.update(reward_participant_id: reward_participant.id) if @coupon.present?

        ## Create participate action entry, update participant bonus points, send email coupon code
        generate_participant_action
      else
        {success: false, message: 'You have already claimed this reward earlier.'}
      end

    elsif @participant.present? && @campaign.present?
      rewards = @campaign.rewards.current_active
      rewards.each do |reward|
        if reward.selection == 'milestone'
          ## Check for Reward Availability
          if reward.claims < reward.limit
            ## Check Whether Participant Claimed Reward Previously or Not
            reward_participant = reward.reward_participants.where(participant_id: @participant.id).first_or_initialize
            if reward_participant.new_record?
              is_eligible = reward.eligible? @participant
              if is_eligible
                reward_participant.save

                # Grab a Coupon for Participant & Assign it
                coupon = reward.coupons.where(reward_participant_id: nil).first
                coupon.update(reward_participant_id: reward_participant.id) if coupon.present?

                begin
                  participant_action = ParticipantAction.new(participant_id: @participant.id, points: reward.points,
                                                             action_type: 'claim_reward', title: 'Won a Milestone Reward',
                                                             details: reward.name, actionable_id: reward.id,
                                                             actionable_type: reward.class.name, coupon: coupon.try(:code),
                                                             campaign_id: @participant.campaign_id, ahoy_visit_id: @visit.try(:id))
                  participant_action.save!

                  ## Assign Bonus Points to Participant if Available
                  if reward.points.present?
                    @participant.points = @participant.points.to_i + reward.points.to_i
                    @participant.unused_points = @participant.unused_points.to_i + reward.points.to_i
                    @participant.save(:validate => false)
                  end

                  RewardMailer.milestone_reward_completion(reward, @participant, coupon).deliver
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

  private

  ## Create participate action entry, update participant bonus points, send email coupon code
  def generate_participant_action
    if @reward.selection == 'redeem'
      title = 'Won a Cash In Reward'
      mailer_method = 'cash_in_reward'
    elsif @reward.selection == 'instant'
      title = 'Won an Instant Reward'
      mailer_method = 'instant_reward'
    elsif @reward.selection == 'manual'
      title = 'Won a Manual Reward'
      mailer_method = 'manual_reward'
    elsif @reward.selection == 'sweepstake'
      title = 'Won a Sweepstake Reward'
      mailer_method = 'sweepstake_reward'
    end

    begin
      ## insert the participant action for any reward
      participant_action = ParticipantAction.new(participant_id: @participant.id, points: @reward.points,
                             action_type: 'claim_reward', title: title, details: @reward.name,
                             actionable_id: @reward.id, actionable_type: @reward.class.name,coupon: @coupon.try(:code),
                             user_agent: @request.try(:user_agent), ip_address: @request.try(:ip), campaign_id: @participant.campaign_id, ahoy_visit_id: @visit.try(:id))
      participant_action.save!

      ## Assign Bonus Points to Participant if Available except instant reward type
      if @reward.selection != 'instant'
        @participant.points = @participant.points.to_i + @reward.points.to_i
        @participant.unused_points = @participant.unused_points.to_i + @reward.points.to_i
        @participant.save(validate: false)
      end

      # Send an email with coupon to participant to user
      RewardMailer.send(mailer_method, @reward, @participant, @coupon).deliver

      response = {success: true, message: 'Reward claimed successfully.'}
    rescue Exception => e
      Rails.logger.info "ERROR: Reward id: #{@reward.id} #{@reward.selection} Completion Participant Action Entry Failed --> #{e.message}"
      response = {success: false, message: 'Reward claimed successfully, Participant Action Entry failed.'}
    end
  end
end
