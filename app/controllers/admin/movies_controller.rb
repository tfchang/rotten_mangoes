require 'open-uri'

class Admin::MoviesController < ApplicationController

  before_action :verify_admin

  def new
  end

  def create
    movie_hash = Movie.load_omdb(params[:imdb_id], params[:title])
    @movie = Movie.create(movie_hash)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was loaded from OMDB."
    else
      render :new
    end
  end

end