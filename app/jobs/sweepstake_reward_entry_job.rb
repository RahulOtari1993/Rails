class SweepstakeRewardEntryJob

  ## Choose the sweepstake reward winners for all campaigns
  def perform(arg)
    Campaign.active.each do |campaign|
      Rails.logger.info "******** Sweepstake entry job for Campaign: #{campaign.name} -- Start ********"
      rewards = campaign.rewards.where(selection: 'sweepstake', finish: (DateTime.now.yesterday.beginning_of_day .. DateTime.now.yesterday.end_of_day)).sort
      unless rewards.blank?
        rewards.each do |reward|
          Rails.logger.info "******** Draw sweepstake winner for Reward: #{reward.name} -- Start ********"
          ## create sweepstake entries and choose a sweepstake winner
          reward.choose_sweepstake_winner
          Rails.logger.info "******** Draw sweepstake winner for Reward: #{reward.name} -- End ********"
        end
      end
      Rails.logger.info "******** Sweepstake entry job for Campaign:  #{campaign.name} -- End ********"
    end
  end
end
