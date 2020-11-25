module WelcomeHelper

  def get_remaining_time_in_words(end_date)
    # TimeDifference.between(Time.now, end_date ).humanize
    duration = (end_date - Time.now).to_i
    secs  = duration
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    if days > 0
      time_diff = "#{days}d #{hours % 24}h"
    elsif hours > 0
      time_diff = "#{hours}h #{mins % 60}mins"
    elsif mins > 0
      time_diff = "#{mins} mins #{secs % 60}sec"
    elsif secs >= 0
      time_diff = "#{secs}sec"
    end
    time_diff
  end

  def get_completed_time_in_words(completed_time)
    time_diff = distance_of_time_in_words(Time.now, completed_time.localtime)
    time_diff
  end
end
