class SweepstakeRewardWinnerService
  def initialize(reward_id)
    @reward = Reward.where(id: reward_id).first rescue nil
    @campaign = @reward.campaign rescue nil
  end

  ## create sweepstake entries and choose a sweepstake reward winner
  def process
    if @campaign.present? && @reward.present?
      @participants =  @campaign.participants.sort

      unless @participants.blank?
        sweepstake_entry_weights = {}
        predicted_winners = []
        predicted_winners_count = 0
        @participants.each do |participant|
          ## calculate no of sweepstake entries based on points earned during reward duration
          no_of_entries = 0
          total_earned_points = participant.participant_actions.where(created_at: @reward.start..@reward.finish).pluck(:points).compact.sum
          no_of_entries = (total_earned_points / @reward.sweepstake_entry.to_i)

          ## create all the sweepstake entries for participant based on the earned points
          (1..no_of_entries).each do |item|
            SweepstakeEntry.create(reward_id: @reward.id, participant_id: participant.id)
          end

          ## Calculate probability of each user
          sweepstake_entry_weights[participant.id] = no_of_entries if (no_of_entries > 0)
        end
        predicted_winners_count = (@reward.limit.to_i > sweepstake_entry_weights.keys.length) ? sweepstake_entry_weights.keys.length : @reward.limit.to_i

        ## choose the sweepstake winner randomly through loop
        unless sweepstake_entry_weights.blank?
          pickup = Pickup.new(sweepstake_entry_weights, uniq: true)
          predicted_winners = pickup.pick(predicted_winners_count)

          ## update sweepstake entry for participants
          predicted_winners.each do |participant_id|
            entry = @reward.sweepstake_entries.where(participant_id: participant_id).first
            entry.update(winner: true)

            ##Claim the sweepstake reward for predicted winners
            reward_service = RewardsService.new(participant_id, @reward.id)
            reward_service.process
          end
        end

      end

    end
  end
end
