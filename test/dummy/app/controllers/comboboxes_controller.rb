class ComboboxesController < ApplicationController
  before_action :set_states, except: :new_options

  def plain
  end

  def open
  end

  def html_options
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

  def list_autocomplete
  end

  def async
  end

  def prefilled_async
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def prefilled_form
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def async_html
  end

  def render_in
  end

  private
    delegate :combobox_options, :html_combobox_options, to: "ApplicationController.helpers", private: true

    def set_states
      @states = combobox_options State.all, id: :abbreviation, value: :abbreviation, display: :name
    end
end
