class StateChipsController < ApplicationController
  def new
    @states = State.find params[:combobox_values].split(",")
  end
end
