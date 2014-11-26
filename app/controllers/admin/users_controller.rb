class Admin::UsersController < ApplicationController
  def index
    @admin_users = User.all
  end

  def show
    @admin_user = User.find(params[:id])
  end

  # def destroy
  #   @admin_user = User.new
  # end
end