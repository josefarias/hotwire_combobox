class MovieRatingsController < ApplicationController
  def index
    render turbo_stream: helpers.async_combobox_options(Movie.ratings)
  end
end
