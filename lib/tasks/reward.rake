
namespace :reward do

  ## Choose the sweepstake reward winners for all campaigns
  task :sweepstake_stake_reward_entries => :environment do
    Rails.logger.info "******** Sweepstake Entry Job is Started AT #{Time.current} ********"
    # SweepstakeRewardEntryJob.perform
    Rails.logger.info "******** Sweepstake Entry Job is ENDED AT #{Time.current} ********"
  end

end
