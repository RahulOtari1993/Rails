class ApplicationController < ActionController::Base
  before_action :set_organization

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_organization
    # @organization ||= Organization.where(sub_domain: request.subdomain).first
    @domain = DomainList.where(domain: request.subdomain).first
    if @domain.present?
      @organization = Organization.where(id: @domain.organization_id).first
      @campaign = Campaign.where(id: @domain.campaign_id).first
    else
      # binding.pry
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

  def image_compression(image_name_hax, photo_filename, thumb_filename, image_url)
    open(Rails.root.join('public', 'image_compression', image_name_hax + '.jpg'), 'wb') do |file|
      file << open(image_url).read
    end

    ## Check Image Width
    image_obj = MiniMagick::Image.open(Rails.root.join('public', 'image_compression', image_name_hax + '.jpg'))
    image_width = image_obj[:width]

    if image_width >= 1440
      # Generate Photo Image
      system("convert -strip -interlace Plane -gaussian-blur 0.05 -quality 60% -resize 1440x #{Rails.root.join('public', 'image_compression', image_name_hax + '.jpg')} #{Rails.root.join('public', 'image_compression', photo_filename)}")

      # Generate Thumb Image
      system("convert -define jpeg:size=596x #{Rails.root.join('public', 'image_compression', photo_filename)} -thumbnail '596x' #{Rails.root.join('public', 'image_compression', thumb_filename)}")
    else
      # Generate Photo Image
      system("convert -strip -interlace Plane -gaussian-blur 0.05 #{Rails.root.join('public', 'image_compression', image_name_hax + '.jpg')} #{Rails.root.join('public', 'image_compression', photo_filename)}")

      # Generate Thumb Image
      if image_width >= 596
        system("convert -define jpeg:size=596x #{Rails.root.join('public', 'image_compression', photo_filename)} -thumbnail '596x' #{Rails.root.join('public', 'image_compression', thumb_filename)}")
      else
        system("convert -strip -interlace Plane -gaussian-blur 0.05 #{Rails.root.join('public', 'image_compression', photo_filename)} #{Rails.root.join('public', 'image_compression', thumb_filename)}")
      end
    end
  end

  def remove_local_files(image_name_hax, photo_filename, thumb_filename)
    File.delete(Rails.root.join('public', 'image_compression', image_name_hax + '.jpg'))
    File.delete(Rails.root.join('public', 'image_compression', photo_filename))
    File.delete(Rails.root.join('public', 'image_compression', thumb_filename))
  end
end
