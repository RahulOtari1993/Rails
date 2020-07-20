
namespace :reward do

  ## Choose the sweepstake reward winners for all campaigns
  task :sweepstake_stake_reward_entries => :environment do
    Rails.logger.info "*********** Cron Job execute --  start ***********"
    Rails.logger.info "*********** Time: #{DateTime.now} ***********"

    # SweepstakeRewardEntryJob.perform
    Rails.logger.info "*********** Cron Job executed --  end ***********"
  end

end
