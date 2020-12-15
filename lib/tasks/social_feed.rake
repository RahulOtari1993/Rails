
namespace :social_feed do
  ## Fetch the facebook feeds for all campaigns
  task :facebook_feed_entries => :environment do
    Rails.logger.info "******** Facebook feed entry job is Started AT #{Time.current} ********"
    FacebookSocialFeedEntryJob.perform_now
    Rails.logger.info "******** Facebook feed entry job is ENDED AT #{Time.current} ********"
  end

  ## Fetch the Instagram feeds for all campaigns
  task :instagram_feed_entries => :environment do
    Rails.logger.info "******** Instagram feed entry job is STARTED AT #{Time.current} ********"
    InstagramSocialFeedEntryJob.perform_now
    Rails.logger.info "******** Instagram feed entry job is ENDED AT #{Time.current} ********"
  end
end
