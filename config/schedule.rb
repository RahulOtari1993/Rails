set :output, "log/cron_log.log"

## Choose sweepstake winner for sweepstake rewards as per UTC
every 1.day, at: '8:00 am' do
  rake "reward:sweepstake_stake_reward_entries"
end

## Fetch the Facebook social feed content from api for all campaigns as per UTC
every 4.hours do
  rake "social_feed:facebook_feed_entries"
end

## Fetch the Instagram social feed content from api for all campaigns as per UTC
every 4.hours do
  rake "social_feed:instagram_feed_entries"
end

## Refresh Instagram Tokens for all campaigns as per UTC
every 45.days do
  rake "social_feed:refresh_instagram_tokens"
end
