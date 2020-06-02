class Admin::Campaigns::NetworksController < Admin::Campaigns::BaseController
  before_action :authenticate_user!, except: [:connect_facebook]

  def index
  end

  # call back url
  def connect_facebook
    Rails.logger.debug "******** Call back from facebook started *********"
    @network = @campaign.networks.new(platform: "facebook")
    binding.pry
    Rails.logger.debug "******** #{request.params} *********"
    Rails.logger.debug "******** #{request} *********"

    Rails.logger.debug "******** redirected to networks index page *********"
    flash[:notice] = "You are connected to Facebook Success."
    redirect_to :index
  end

  private

end
