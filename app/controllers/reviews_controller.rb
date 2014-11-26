class ReviewsController < ApplicationController
  def new
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to @movie, notice: "Your review was saved."
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:text, :rating_out_of_ten)
  end
end
