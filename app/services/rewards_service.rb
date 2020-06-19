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
          is_eligible = reward.eligible? @participant
          Rails.logger.info "============== is_eligible #{is_eligible.inspect} =============="
        end
      end
    end
  end
end