class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # auto login
      session[:user_id] = @user.id 
      redirect_to movies_path, notice: "Welcome, #{@user.firstname}!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end
