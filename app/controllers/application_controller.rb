class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!, unless: :devise_controller?
  private

  def current_user
    @current_user ||= FacebookUser.find(session[:facebook_user_id]) if session[:facebook_user_id]
  end
  helper_method :current_user
end
