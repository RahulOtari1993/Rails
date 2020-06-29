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
      filter.rule_type
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Condition
  def rule_condition_value(filter, value)
    if filter.present?
      filter.rule_condition
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Value
  def rule_event_value(filter, value, type)
    if filter.present?
      filter.rule_type == type ? filter.rule_value : value
    else
      value
    end
  end

  ## User Segment Set DISABLED Fields
  def rule_make_disabled(filter, type)
    if filter.present?
      !type.include?(filter.rule_type)
    else
      !type.include?('challenges_completed')
    end
  end

  ## User Segment Set VISIBLE Fields
  def rule_make_visible(filter, type)
    if filter.present?
      type.include?(filter.rule_type) ? 'block' : 'none'
    else
      type.include?('challenges_completed') ? 'block' : 'none'
    end
  end

  ## Show Hide Reward Rule Segment
  def rule_display_user_segments
    @reward.rule_applied ? 'block' : 'none'
  end
end