 module RewardHelper

 ## Set reward Start Time
  def start_time
    new_record? ? '' : @reward.start.strftime('%I:%M %p')
  end

  ## Set reward Finish Date
  def finish_date
    if new_record?
      ''
    else
      @reward.finish.present? ? @reward.finish.strftime('%m/%d/%Y') : ''
    end
  end

  ## Set reward Finish Time
  def finish_time
    if new_record?
      ''
    else
      @reward.finish.present? ? @reward.finish.strftime('%I:%M %p') : ''
    end
  end

  ## Set Name Convention String for User Segment
  def name_convention(filter = nil)
    filter.present? ? filter.id : '___NUM___'
  end

  ## Set ID Convention String for User Segment
  def id_convention(filter = nil)
    filter.present? ? filter.id : '___ID___'
  end

  ## User Segment Set Default Value of Event's User Segment Type
  def reward_event_value(filter, value)
    if filter.present?
      filter.reward_event
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Condition
  def condition_value(filter, value)
    if filter.present?
      filter.reward_condition
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Value
  def event_value(filter, value, type)
    if filter.present?
      filter.reward_event == type ? filter.reward_value : value
    else
      value
    end
  end

  ## User Segment Set DISABLED Fields
  def make_disabled(filter, type)
    if filter.present?
      !type.include?(filter.reward_event)
    else
      !type.include?('age')
    end
  end

  ## User Segment Set VISIBLE Fields
  def make_visible(filter, type)
    if filter.present?
      type.include?(filter.reward_event) ? 'block' : 'none'
    else
      type.include?('age') ? 'block' : 'none'
    end
  end
end