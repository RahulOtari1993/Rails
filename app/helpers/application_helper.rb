module ApplicationHelper
  def all_business_humanize
    Business.all.map { |business| [business.name.upcase_first, business.id] }
  end
end
