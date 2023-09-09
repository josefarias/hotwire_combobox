class ComboboxesController < ApplicationController
  before_action :set_states

  def plain
  end

  def open
  end

  def html
  end

  private
    State = Data.define(:content, :filterable_as)

    def set_states
      @states = [
        State.new(content: "Alabama", filterable_as: "Alabama"),
        State.new(content: "Florida", filterable_as: "Florida"),
        State.new(content: "Michigan", filterable_as: "Michigan"),
        State.new(content: "Minnesota", filterable_as: "Minnesota"),
        State.new(content: "Mississippi", filterable_as: "Mississippi"),
        State.new(content: "Missouri", filterable_as: "Missouri")
      ]
    end
end
