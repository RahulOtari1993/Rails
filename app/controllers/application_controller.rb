class ApplicationController < ActionController::Base
  before_action :set_organization

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  def set_organization
    # @organization ||= Organization.where(sub_domain: request.subdomain).first
    @domain = DomainList.where(domain: request.subdomain).first
    if @domain.present?
      @organization = Organization.where(id: @domain.organization_id).first
      @campaign = Campaign.where(id: @domain.campaign_id).first
    else
      @organization = Organization.where(sub_domain: request.subdomain).first
    end

    unless @organization.present?
      # TODO: Org Not Found Page Redirection
      # flash[:error] = "Unknown Organization: #{request.subdomain}"
      # redirect_to(request.referrer || root_path)
    end
    # rescue ActiveRecord::RecordNotFound
    # raise ActionController::RoutingError.new("Unknown Organization: #{request.subdomain}")
  end

  private

  ## Redirection if User is Not Authorised
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = I18n.t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end

  ## Set Current Participant to Access in Models
  def set_current_participant
    Participant.current = current_participant
  end

  protected

  ## Return Success Response
  def render_success code, status, message, data = {}
    render json: {
        code: code,
        status: status,
        message: message,
        data: data
    }
  end

  ## Return Error Response
  def return_error(code, status, message, data = {})
    render json: {
        code: code,
        status: status,
        message: message,
        data: data
    }
  end

  ## Check for Latest App Version
  def validate_app_version
    if Rails.application.credentials[Rails.env.to_sym][:app_version].to_f > request.headers["app-version"].to_f
      return_error 500, false, 'Please check your app version.', {}
    end
  end
end
