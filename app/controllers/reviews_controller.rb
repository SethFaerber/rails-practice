class ReviewsController < ApplicationController

  before_action :set_movie


  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)


    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end

  end

  private

  def review_params
    params.require(:review).permit(:name, :comment, :stars)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end

#
# def instantiate
#   "I've been instantiated."
# end
#
# def run(method_name_or_symbol)
#   method_name_or_symbol
# end
#
# run instantiate
# run :instantiate