class FacebookOmniauthSetup
  # OmniAuth expects the class passed to setup to respond to the #call method.
  # env - Rack environment
  def self.call(env)    
    new(env).setup
  end

  # Assign variables and create a request object for use later.
  # env - Rack environment
  def initialize(env)
    Rails.logger.info "============== IN initialize =============="
    @env = env
    @request = ActionDispatch::Request.new(env)
  end

  public

  # The main purpose of this method is to set the consumer key and secret.
  def setup
    Rails.logger.info "============== IN SETUP =============="
    @env['omniauth.strategy'].options.merge!(custom_credentials)
  end

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials   
    Rails.logger.info "============== IN LIB =============="
    conf = GlobalConfiguration.first

    {
      client_id: conf.facebook_app_id,
      client_secret: conf.facebook_app_secret
    }
  end
end