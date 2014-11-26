class Admin::UsersController < ApplicationController
  
  before_action :verify_admin

  def index
    @admin_users = User.all
  end

  def show
    @admin_user = User.find(params[:id])
  end

  def edit
    @admin_user = User.find(params[:id])
  end

  def update
    @admin_user = User.find(params[:id])

    if @admin_user.update(user_params)
      redirect_to admin_user_path(@admin_user)
    else
      render :edit
    end
  end

  def destroy
    @admin_user = User.find(params[:id])
    @admin_user.destroy
    redirect_to admin_users_path
  end



  private

  def verify_admin
    unless is_admin?
      redirect_to root, alert: "You are not an administrator!"
    end
  end

  def is_admin?
    current_user
    @current_user && @current_user.id == 1
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email)
  end
end