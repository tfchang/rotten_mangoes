class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def restrict_access
    unless current_user
      redirect_to new_session_path, alert: "You must log in to perform this action."
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id].to_i) if session[:user_id]
  end

  def verify_admin
    unless is_admin?
      redirect_to movies_path, alert: "You are not an administrator!"
    end
  end

  def is_admin?
    return true if session[:admin_id]
    current_user
    @current_user && @current_user.admin
  end

  def preview_mode?
    is_admin? && (session[:user_id].to_i != session[:admin_id].to_i)
  end

  helper_method :current_user, :is_admin?, :preview_mode?
end
