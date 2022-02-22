class RegistrationsController < DeviseTokenAuth::RegistrationsController 
    # GET /resource/sign_up
  def create
    user = User.new(sign_up_params)
    if user.save 
      render json: user.as_json, status: :ok, message:'User created successfully'
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    render json: User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :not_found
  end

  private
  def sign_up_params
    params.require(:user).permit(:email,:password,:password_confirmation,:uid,:provider,:name)
  end
end
