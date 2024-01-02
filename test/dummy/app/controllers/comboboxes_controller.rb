class ComboboxesController < ApplicationController
  before_action :set_states, except: :new_options

  def plain
  end

  def open
  end

  def html
  end

  def prefilled
  end

  def required
  end

  def formbuilder
  end

  def new_options
  end

  def inline_autocomplete
  end

  private
    delegate :combobox_options, to: "ApplicationController.helpers", private: true

    def set_states
      @states = combobox_options State.all, id: :abbreviation, value: :abbreviation, display: :name
    end
end
