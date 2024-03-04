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
      set_page_and_extract_portion_from Movie.search(params[:q]).alphabetically, per_page: 5
    end
end
