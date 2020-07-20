# env 'CRON_TZ', 'America/Los_Angeles'
set :environment, :development
set :output, "log/cron_log.log"

every 1.minute do
  runner "Reward.sweepstack_cron"
end
