class StateChipsController < ApplicationController
  before_action :set_states

  def new
    render turbo_stream: helpers.combobox_selection_chips_for(@states, display: :name, value: :id)
  end

  def new_html
  end

  def new_dismissing
    render turbo_stream: helpers.dismissing_combobox_selection_chips_for(@states, display: :name, value: :id)
  end

  private
    def set_states
      @states = State.find params[:combobox_values].split(",")
    end
end
