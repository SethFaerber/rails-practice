class NinetiesController < ApplicationController

  def index
    @movies = Movie.from_nineties
  end

end
