class ReviewsController < ApplicationController

  before_action :restrict_access
  before_action :load_movie

  def new
    @review = @movie.reviews.build
  end

  def create
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to @movie, notice: "Your review was saved."
    else
      render :new
    end
  end

  private

  def load_movie
    @movie = Movie.find(params[:movie_id].to_i)
  end

  def review_params
    params.require(:review).permit(:text, :rating_out_of_ten)
  end
end
