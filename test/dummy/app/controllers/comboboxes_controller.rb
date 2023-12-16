class ComboboxesController < ApplicationController
  before_action :set_states

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

  private
    delegate :combobox_options, to: "ApplicationController.helpers", private: true

    def set_states
      @states = combobox_options [
        { id: "AL", display: "Alabama" },
        { id: "FL", display: "Florida" },
        { id: "MI", display: "Michigan" },
        { id: "MN", display: "Minnesota" },
        { id: "MS", display: "Mississippi" },
        { id: "MO", display: "Missouri" }
      ]
    end
end
