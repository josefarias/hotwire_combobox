class MoviesController < ApplicationController
  before_action :set_page

  def index
  end

  def index_html
  end

  def index_with_blank
  end

  def index_with_blank_html
  end

  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to enum_url, notice: "Movie was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_page
      movies = params[:full_search] ? Movie.full_search(params[:q]) : Movie.search(params[:q])
      set_page_and_extract_portion_from movies.alphabetically, per_page: 5
    end

    def movie_params
      params.require(:movie).permit(:title, :rating)
    end
end
