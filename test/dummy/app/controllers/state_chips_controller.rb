class StateChipsController < ApplicationController
  before_action :set_states

  def new
  end

  def new_html
  end

  private
    def set_states
      @states = State.find params[:combobox_values].split(",")
    end
end
