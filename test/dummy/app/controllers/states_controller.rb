class StatesController < ApplicationController
  before_action :set_page

  def index
    if @page
      @states = @page.records
      @next_page = @page.last? ? nil : @page.next_param
    else
      @states = State.search params[:q]
    end
  end

  private
    def set_page
      if params[:page]
        set_page_and_extract_portion_from State.search(params[:q]), per_page: 5
      end
    end
end
