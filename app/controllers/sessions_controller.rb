class SessionsController < DeviseTokenAuth::SessionsController 
    def create
    params_hash = sign_up_params

    unless params_hash[:email].present?
      render_email_missing
    else
      @resource = User.where(email: params_hash[:email]).first rescue nil
      unless @resource.present?
        json = {
            name: col_value('name'),
            email: col_value('email'),
            phone: col_value('phone'),
            password: SecureRandom.hex(8),
            sport_id: col_value('sport_id'),
            confirmed_at: Time.now
        }

        @resource = User.new(json)
        @resource.save!
      end
      @token = @resource.create_token
      @resource.save(:validate => false)
      sign_in(:user, @resource, store: false)

      render_success 200, true, 'Logged in successfully', @resource.as_json
    end
  end

  protected

    ## Manage Strong Params
    def sign_up_params
      parameters = params.permit(:facebook_id,:email)

      parameters
    end

    ## Render Email not exists in params error
    def render_email_missing
      return_error 400, false, 'Please enter email address', {}
    end

    def col_value(col_name)
      params.has_key?(col_name) ? params[col_name] : ''
    end
end
