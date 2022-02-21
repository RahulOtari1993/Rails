class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  protected
  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end
  def authenticate_current_user
    head :unauthorized if current_user_get.nil?
  end  
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
    
    
  ## Pagination Page Number
  def page
    @page ||= params[:page] || 1
  end
    
  ## Pagination Per Page Records
  def per_page
    @per_page ||= params[:per_page] || 20
  end
    
      ## Set Product & Return ERROR if not found
  def set_sport
    @sport = Sport.where(id: params[:sport_id]).first
    
    unless @sport
      return return_error 404, false, 'Product not found', {}
    end
  end
end