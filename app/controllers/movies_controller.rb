class MoviesController < ApplicationController

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)

    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)

      # These two lines are the same as the third. How does the third know that notice: is the same
      # as setting the notice property on the flash hash?
      #
      # flash[:notice] = "Movie successfully updated!"
      # redirect_to @movie

      redirect_to @movie, notice: "Movie successfully updated!"

    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully added!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, status: :see_other, alert: "Movie has been deleted."
  end

  private

  def movie_params
    params.require(:movie).
      permit(
        :title,
        :description,
        :rating,
        :released_on,
        :total_gross,
        :director,
        :duration,
        :image_file_name,
        genre_ids: []
      )
  end
end
