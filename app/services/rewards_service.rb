class RewardsService
  def initialize(participant_id)
    @participant_id = participant_id
  end

  ## Process Rewards for Participant Eligibility
  def process
    Rails.logger.info "============== IN PROCESS START =============="
    Rails.logger.info "============== @participant_id #{@participant_id.inspect} =============="
    Rails.logger.info "============== IN PROCESS END =============="
  end
end