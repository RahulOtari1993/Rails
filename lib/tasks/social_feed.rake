
namespace :social_feed do
  ## Fetch the facebook feeds for all campaigns
  task :facebook_feed_entries => :environment do
    Rails.logger.info "******** Facebook feed entry job is Started AT #{Time.current} ********"
    FacebookSocialFeedEntryJob.perform
    Rails.logger.info "******** Facebook feed entry job is ENDED AT #{Time.current} ********"
  end
end
