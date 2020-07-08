 module RewardHelper

 ## Set reward Start Time
  def reward_start_date
    reward_new_record? ? '' : @reward.start.strftime('%m/%d/%Y')
  end

  ## Set reward Finish Date
  def reward_finish_date
    if reward_new_record?
      ''
    else
      @reward.finish.present? ? @reward.finish.strftime('%m/%d/%Y') : ''
    end
  end

  ## check new record
  def reward_new_record?
    @reward.new_record?
  end

  ## Image Load While Editing a Challenge
  def reward_image_load
    if @reward.new_record?
      "<img id='reward-image-preview' class = 'reward-image-preview' />"
    else
      "<img id='reward-image-preview' class = 'reward-image-preview' src='#{@reward.image.url(:banner)}'/>"
    end
  end

  ## Set Name Convention String for User Segment
  def reward_name_convention(filter = nil)
    filter.present? ? filter.id : '___NUM___'
  end

  ## Set ID Convention String for User Segment
  def reward_id_convention(filter = nil)
    filter.present? ? filter.id : '___ID___'
  end

  ## User Segment Set Default Value of Event's User Segment Type
  def reward_event(filter, value)
    if filter.present?
      filter.reward_event
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Condition
  def reward_condition_value(filter, value)
    if filter.present?
      filter.reward_condition
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Value
  def reward_event_value(filter, value, type)
    if filter.present?
      filter.reward_event == type ? filter.reward_value : value
    else
      value
    end
  end

  ## User Segment Set DISABLED Fields
  def reward_make_disabled(filter, type)
    if filter.present?
      !type.include?(filter.reward_event)
    else
      !type.include?('age')
    end
  end

  ## User Segment Set VISIBLE Fields
  def reward_make_visible(filter, type)
    if filter.present?
      type.include?(filter.reward_event) ? 'block' : 'none'
    else
      type.include?('age') ? 'block' : 'none'
    end
  end

  ## User Segment List for Rewards
  def reward_user_segment_list
    filter_list = []
    RewardFilter::EVENTS.each do |filter_type|
      if filter_type == 'age' || filter_type == 'tags' || filter_type == 'gender'
        filter_list.push([filter_type.titleize, filter_type])
      elsif filter_type == 'current-points'
        filter_list.push(['Current Points', filter_type])
      elsif filter_type == 'lifetime-points'
        filter_list.push(['Lifetime Points', filter_type])
      elsif filter_type == 'challenge'
        filter_list.push(['Challenges Completed', filter_type])
      elsif filter_type == 'login'
        filter_list.push(['User Logins', filter_type])
      end
    end

    filter_list
  end

  ## Show Hide RewardUser Segment
  def display_reward_user_segments
    @reward.filter_applied ? 'block' : 'none'
  end

  ## Return Reward User Segment Filter Type Options
  def reward_filter_type
    Reward::filter_types.map{|k,v| [k == 'all_filters' ? 'All' : 'Any', k]}
  end

  ## Return Reward User Segment Filter Type Options
  def reward_rule_type
    Reward::rule_types.map{|k,v| [k == 'all_rules' ? 'All' : 'Any', k]}
  end

  ## Return Reward Types selection Options
  def reward_types
    Reward::SELECTIONS.map { |val| [(val == "redeem" ? "Cash-In" : val.humanize), val] if !["threshold", "selection"].include?(val)}.compact
  end
 end
