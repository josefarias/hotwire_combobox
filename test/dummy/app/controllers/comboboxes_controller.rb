class ComboboxesController < ApplicationController
  before_action :set_states

  def new
  end

  def open
  end

  def html
  end

  private
    def set_states
      @states = [ "Alabama", "Florida", "Michigan", "Minnesota", "Mississippi", "Missouri" ]
    end
end
