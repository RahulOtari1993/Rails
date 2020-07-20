set :output, "log/cron_log.log"

## Choose sweepstake winner for sweepstake rewards
every 1.day, at: '8:00 am' do
  rake "reward:sweepstake_stake_reward_entries"
end

## Fetch the social feed content from api for all campaigns
every 4.hours do
  rake "social_feed:facebook_feed_entries"
end
