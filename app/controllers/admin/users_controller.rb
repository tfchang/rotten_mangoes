class Admin::UsersController < ApplicationController
  
  before_action :verify_admin

  def index
    @admin_users = User.all.page(params[:page]).per(10)
  end

  def new
    @admin_user = User.new
  end

  def create
    @admin_user = User.new(user_params)

    if @admin_user.save
      redirect_to admin_user_path(@admin_user), notice: "#{@admin_user.full_name} was created."
    else
      render :new
    end
  end

  def show
    @admin_user = User.find(params[:id].to_i)
  end

  def edit
    @admin_user = User.find(params[:id].to_i)
  end

  def update
    @admin_user = User.find(params[:id].to_i)

    if @admin_user.update(user_params)
      redirect_to admin_user_path(@admin_user), notice: "#{@admin_user.full_name} was updated."
    else
      render :edit
    end
  end

  def destroy
    @admin_user = User.find(params[:id].to_i)
    UserMailer.delete_user_email(@admin_user).deliver
    @admin_user.destroy

    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end
end