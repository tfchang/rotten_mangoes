require 'open-uri'

class Admin::MoviesController < ApplicationController

  before_action :verify_admin

  def new
    @movie = Movie.new
  end

  def create
    movie_hash = Movie.load_omdb(movie_params)
    if movie_hash.blank?
      @movie = Movie.new
      @movie.errors[:base] << "Failed to load from OMDB!"
      render :new
      return
    end

    @movie = Movie.create(movie_hash)
    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was loaded from OMDB."
    else
      render :new
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:imdb_id, :title)
  end

end