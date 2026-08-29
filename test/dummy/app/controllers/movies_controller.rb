class MoviesController < ApplicationController
  before_action :stall_slow_query
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
    # Holds one query's response open so a later query can answer first. That's how a
    # superseded response arrives late and overwrites the list it no longer describes.
    def stall_slow_query
      sleep params[:latency].to_f if params[:slow_query].present? && params[:q] == params[:slow_query]
    end

    def set_page
      movies = params[:full_search] ? Movie.full_search(params[:q]) : Movie.search(params[:q])
      set_page_and_extract_portion_from movies.alphabetically, per_page: 5
    end
end
