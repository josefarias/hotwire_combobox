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

  private
    def set_states
      @states = [
        Combobox::Option.new(id: "AL", content: "Alabama", filterable_as: "Alabama", autocompletable_as: "Alabama"),
        Combobox::Option.new(id: "FL", content: "Florida", filterable_as: "Florida", autocompletable_as: "Florida"),
        Combobox::Option.new(id: "MI", content: "Michigan", filterable_as: "Michigan", autocompletable_as: "Michigan"),
        Combobox::Option.new(id: "MN", content: "Minnesota", filterable_as: "Minnesota", autocompletable_as: "Minnesota"),
        Combobox::Option.new(id: "MS", content: "Mississippi", filterable_as: "Mississippi", autocompletable_as: "Mississippi"),
        Combobox::Option.new(id: "MO", content: "Missouri", filterable_as: "Missouri", autocompletable_as: "Missouri")
      ]
    end
end
