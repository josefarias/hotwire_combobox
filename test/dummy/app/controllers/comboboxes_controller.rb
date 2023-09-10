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

  private
    State = Data.define(:content, :id, :filterable_as, :autocompletable_as)

    def set_states
      @states = [
        State.new(id: "AL", content: "Alabama", filterable_as: "Alabama", autocompletable_as: "Alabama"),
        State.new(id: "FL", content: "Florida", filterable_as: "Florida", autocompletable_as: "Florida"),
        State.new(id: "MI", content: "Michigan", filterable_as: "Michigan", autocompletable_as: "Michigan"),
        State.new(id: "MN", content: "Minnesota", filterable_as: "Minnesota", autocompletable_as: "Minnesota"),
        State.new(id: "MS", content: "Mississippi", filterable_as: "Mississippi", autocompletable_as: "Mississippi"),
        State.new(id: "MO", content: "Missouri", filterable_as: "Missouri", autocompletable_as: "Missouri")
      ]
    end
end
