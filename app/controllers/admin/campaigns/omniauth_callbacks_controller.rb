class Admin::Campaigns::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  ## Handle Facebook OAuth2 Callbacks
  def facebook
    Rails.logger.info "********************** Facebook Callback Initiated **********************"
    user_agent = request.user_agent
    remote_ip = request.remote_ip
    type = request.env['omniauth.params']['type']

    Rails.logger.info "********* Parameters: #{request.env['omniauth.params']}**********"
    Rails.logger.info "********* Response: #{request.env["omniauth.auth"]}**********"

    if type == 'connect' && request.env['omniauth.params'].has_key?('ci') && request.env['omniauth.params'].has_key?('oi') && request.env['omniauth.params'].has_key?('ui')
      @network = User.facebook_connect(request.env["omniauth.auth"], request.env["omniauth.params"], user_agent, remote_ip, request.env['omniauth.params']['ui'])

      if @network.new_record?
        redirect_to admin_campaign_networks(@campaign), notice: 'Connecting Facebook account failed.'
      else
        redirect_to admin_campaign_networks(@campaign), notice: 'Facebook account connected successfully.'
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to admin_campaign_networks(@campaign)
    end
  end

  ## Setup OAuth Details for Facebook
  def setup
    Rails.logger.info "********************** Setup Facebook Configuration **********************"
    conf = GlobalConfiguration.first
    request.env['omniauth.strategy'].options[:client_id] = conf.facebook_app_id
    request.env['omniauth.strategy'].options[:client_secret] = conf.facebook_app_secret
    render :json => {:success => "Configuration Changes Successfully"}.to_json, :status => 404
  end

end
