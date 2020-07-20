set :output, "log/cron_log.log"

## Choose sweepstake winner for sweepstake rewards
every 1.day, at: '11:25 am' do
  rake "reward:sweepstake_stake_reward_entries"
end
