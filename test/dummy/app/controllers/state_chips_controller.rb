require "ostruct"

class StateChipsController < ApplicationController
  # System tests reset this and assert it stays at 0 to prove that
  # mounting a multiselect with no preselected value doesn't POST to
  # multiselect_chip_src. Capybara runs the rails server in-process so
  # the class variable is visible to test asserts.
  @@request_count = 0
  def self.request_count; @@request_count; end
  def self.reset_request_count!; @@request_count = 0; end

  before_action { @@request_count += 1 }
  before_action :set_states, except: :create_possibly_new

  def create
    render turbo_stream: helpers.combobox_selection_chips_for(@states)
  end

  def create_html
  end

  def create_possibly_new
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
