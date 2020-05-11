module ApplicationHelper

  def flash_toaster_class(level)
    case level
    when 'notice' then "error"
    when 'success' then "error"
    when 'error' then "error"
    when 'alert' then "error"
    end
  end

  def flash_class(level)
    case level
    when 'notice' then "alert alert-info"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-danger"
    end
  end

  ## Check for Active Menu Class & Set it
  def is_active_menu(c_name, a_name = [])
    return 'active' if controller?(c_name) && action?(a_name)

    ''
  end

  ## Active Menu Controller Name Checks
  def controller?(name)
     name.include?(controller_name)
  end

  ## Active Menu Action Name Checks
  def action?(name)
    name.present? ? name.include?(action_name) : true
  end

  ## Fetch All Tags
  def all_tags_humanize
    ActsAsTaggableOn::Tag.all.map { |tag| [tag.name.upcase_first, tag.name] }
  end
end
