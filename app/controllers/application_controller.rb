class ApplicationController < ActionController::Base

  ## TODO: Allow Onlt Active Super Admins to LogIn

  # # restrict access to admin module for non-admin users
  # def authenticate_admin_user!
  #   d = current_admin_user.try(:is_active?)
  #   binding.pry
  #   raise SecurityError unless current_admin_user.try(:is_active?)
  # end
  #
  # rescue_from SecurityError do |exception|
  #   binding.pry
  #   redirect_to new_admin_user_session_url
  # end
end
