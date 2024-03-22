class StateChipsController < ApplicationController
  before_action :set_states, except: :new_possibly_new

  def new
    render turbo_stream: helpers.combobox_selection_chips_for(@states)
  end

  def new_html
  end

  def new_dismissing
    render turbo_stream: helpers.dismissing_combobox_selection_chips_for(@states)
  end

  def new_possibly_new
    @states = params[:combobox_values].split(",").map do |value|
      State.find_by(id: value) || OpenStruct.new(to_combobox_display: value, id: value)
    end

    render turbo_stream: helpers.combobox_selection_chips_for(@states)
  end

  private
    def set_states
      @states = State.find params[:combobox_values].split(",")
    end
end
