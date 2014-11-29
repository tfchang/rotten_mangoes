require 'open-uri'

class Admin::MoviesController < ApplicationController
  before_action :verify_admin

  def new

  end

  def create
    redirect_to movies_path, notice: "Ten new movies were loaded!"
  end
end