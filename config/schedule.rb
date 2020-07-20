set :output, "log/cron_log.log"

every 1.day, at: '10:55 am' do
  runner "Reward.sweepstack_cron"
end
