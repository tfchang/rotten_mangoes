class MoviesController < ApplicationController
  def index
    sql = search_sql

    if sql.blank?
      @movies = Movie.all.page(params[:page]).per(10)
    else
      @movies = Movie.where(search_sql).page(params[:page]).per(5)
    end
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

  def search_sql
    sql_array = []
    
    unless params[:q_title].blank?
      sql_array << "(title like '%#{params[:q_title]}%')"
    end
    unless params[:q_director].blank?
      sql_array << "(director like '%#{params[:q_director]}%')"
    end
    unless params[:q_duration_from].blank?
      sql_array << "(runtime_in_minutes >= #{params[:q_duration_from]})"
    end
    unless params[:q_duration_to].blank?
      sql_array << "(runtime_in_minutes <= #{params[:q_duration_to]})"
    end

    sql = sql_array.join(" AND ")
  end
end
