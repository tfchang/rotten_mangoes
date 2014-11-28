class MoviesController < ApplicationController
  before_action :restrict_access, except: [:index, :show]

  def index
    @movies = search.page(params[:page]).per(10)
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted."
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image, :remote_poster_image_url, :description
    )
  end

  def search
    Movie.query_name(params[:q_name]).query_runtime_from(params[:q_runtime_from]).query_runtime_to(params[:q_runtime_to])
  end
end
