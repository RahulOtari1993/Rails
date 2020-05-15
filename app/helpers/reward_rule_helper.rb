 module RewardRuleHelper

  ## Set Name Convention String for User Segment
  def rule_name_convention(filter = nil)
    filter.present? ? filter.id : '___NUM___'
  end

  ## Set ID Convention String for User Segment
  def rule_id_convention(filter = nil)
    filter.present? ? filter.id : '___ID___'
  end

  ## User Segment Set Default Value of Event's User Segment Type
  def rule_event(filter, value)
    if filter.present?
      filter.type
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Condition
  def rule_condition_value(filter, value)
    if filter.present?
      filter.condition
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Value
  def rule_event_value(filter, value, type)
    if filter.present?
      filter.type == type ? filter.value : value
    else
      value
    end
  end

  ## User Segment Set DISABLED Fields
  def rule_make_disabled(filter, type)
    if filter.present?
      !type.include?(filter.type)
    else
      !type.include?('challenges-completed')
    end
  end

  ## User Segment Set VISIBLE Fields
  def rule_make_visible(filter, type)
    if filter.present?
      type.include?(filter.type) ? 'block' : 'none'
    else
      type.include?('challenges-completed') ? 'block' : 'none'
    end
  end

  ## Show Hide User Segment
  def rule_display_user_segments
    @reward.filter_applied ? 'block' : 'none'
  end
end