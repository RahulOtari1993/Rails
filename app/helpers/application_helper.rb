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
end
