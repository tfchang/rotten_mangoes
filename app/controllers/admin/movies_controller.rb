require 'open-uri'

class Admin::MoviesController < ApplicationController

  NUM_MOVIES = 5  # TODO: change to user input

  before_action :verify_admin

  def new
  end

  def create
    NUM_MOVIES.times { @movie = Movie.create(Movie.load_from_omdb) }
    redirect_to movies_path, notice: "Five new movies were loaded!"
  end

end