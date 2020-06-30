class SweepstakeRewardEntryJob

  ## Choose the sweepstake reward winners for all campaigns
  def perform(arg)
    Rails.logger.info "Sweepstake Entry Job is Started AT #{Time.current}"

    Campaign.all each do |campaign|
      rewards = campaign.rewards.where(selection: 'sweepstake', finish: (DateTime.now.yesterday.beginning_of_day .. DateTime.now.yesterday.end_of_day)).sort
      unless rewards.blank?
        rewards.each do |reward|
          Rails.logger.info "Draw Sweepstake Reward winner for #{reward.name} -- Start"
          ## create sweepstake entries and choose a sweepstake winner
          reward.choose_sweepstake_winner
          Rails.logger.info "Draw Sweepstake Reward winner for #{reward.name} -- End"
        end
      end
    end
    Rails.logger.info "Sweepstake Entry Job is ENDED AT #{Time.current}"
  end
end
