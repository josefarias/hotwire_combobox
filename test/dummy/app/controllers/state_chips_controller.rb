class StateChipsController < ApplicationController
  def new
    @state = State.find params[:combobox_value]
  end
end
