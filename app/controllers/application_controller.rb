class ApplicationController < ActionController::Base

  before_action :set_organization
  before_action :handle_referrals

  append_before_action :setup_default_recruit_challenge

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :get_open_graph

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

  def get_open_graph challenge

    @og = nil
    if @campaign && challenge

      if @campaign.present? && @campaign.white_branding
        @conf = CampaignConfig.where(campaign_id: @campaign.id).first
      else
        @conf = GlobalConfiguration.first
      end

      @og = OpenGraphService.new
      @og.site_name = @campaign.name
      @og.title = challenge.name
      @og.description = challenge.description
      @og.image = challenge.image.url
      @og.content_type = 'website'
      @og.fb_app_id = @conf.facebook_app_id
      @og.url = "#{request.protocol}#{request.host}"
    end
    @og
  end

  private

  def setup_default_recruit_challenge
    Rails.logger.info "======== DEFAULT RECRUIT"
    if @campaign
      Rails.logger.info "======== IN campaign ---> #{@campaign.name}"
      @recruit_challenge = Challenge.referral_default_challenge.first
      if @recruit_challenge
        @og = get_open_graph @recruit_challenge
      end
    end
  end

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

  def handle_referrals
    #byebug
    share_service = ShareService.new
    if params[:refid]
      social_share_visit = share_service.record_visit params[:refid], current_visit, current_participant
      if session[:pending_refids].blank?
        session[:pending_refids] = []
      end
      if !session[:pending_refids].include?(params[:refid])
        session[:pending_refids].push(params[:refid])
      end
    end

    if !current_participant.blank? && current_participant.active?
      # We have a signed up and active user so lets process referrals for challenges
      processed_referral_codes = share_service.run current_participant, session[:pending_refids], current_visit

      session[:pending_refids] = session[:pending_refids].reject { |code| processed_referral_codes.include? code }
    end
  end
end
