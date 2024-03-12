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

  private
    def set_page
      movies = params[:full_search] ? Movie.full_search(params[:q]) : Movie.search(params[:q])
      set_page_and_extract_portion_from movies.alphabetically, per_page: 5
    end
end
