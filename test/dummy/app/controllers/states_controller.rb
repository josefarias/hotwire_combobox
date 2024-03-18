class StatesController < ApplicationController
  def index
    @states = State.search params[:q]
  end
end
