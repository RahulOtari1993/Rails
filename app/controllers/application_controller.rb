class ApplicationController < ActionController::Base
  before_action :set_organization

  def set_organization
    @organization ||= Organization.find_by_sub_domain(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError.new("Unknown Organization: #{request.subdomain}")
  end
end
