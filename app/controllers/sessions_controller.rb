class SessionsController < ApplicationController
  before_action :verify_admin, only: [:admin_preview, :admin_switchback]

  def new
  end

  def create
    clear_session
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:admin_id] = user.id if is_admin?
      redirect_to movies_path, notice: "#{user.firstname} is logged in"
    else
      flash.now[:alert] = "Log-in attempt failed!"
      render :new
    end
  end

  def admin_preview
    user = User.find(params[:id].to_i)
    session[:user_id] = user.id
    redirect_to movies_path, notice: "Previewing as #{user.full_name}"
  end

  def admin_switchback
    session[:user_id] = session[:admin_id]
    redirect_to admin_users_path, notice: "Switching back to admin"
  end

  def destroy
    clear_session
    redirect_to movies_path, notice: "Goodbye!"
  end

  private

  def clear_session
    session[:user_id] = nil
    session[:admin_id] = nil
  end
end
