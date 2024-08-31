class ComboboxesController < ApplicationController
  before_action :set_states, except: %i[ new_options grouped_options ]

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

  def freetext_async
  end

  def prefilled_async
    @user = User.first || raise("No user found, load fixtures first.")
    @movie = Movie.first || raise("No movie found, load fixtures first.")
  end

  def prefilled_form
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def prefilled_free_text
  end

  def prefilled_html
  end

  def async_html
  end

  def render_in
  end

  def enum
  end

  def include_blank
  end

  def custom_events
  end

  def custom_attrs
  end

  def conflicting_order
  end

  def render_in_locals
    @hashes = State.limit(3).map { |state| { display: state.name, value: state.abbreviation } }
  end

  def multiselect
  end

  def multiselect_dismissing
  end

  def multiselect_async_html
  end

  def multiselect_prefilled_form
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def multiselect_custom_events
  end

  def multiselect_new_values
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def grouped_options
  end

  def morph
    @user = User.where.not(home_state: nil).first || raise("No user found with home state, load fixtures first.")
  end

  def form_object
    @object = Form.new
  end

  def external_clear
    @user = User.first || raise("No user found, load fixtures first.")
  end

  def dialog
  end

  private
    delegate :combobox_options, :html_combobox_options, to: "ApplicationController.helpers", private: true

    def set_states
      @state_options = combobox_options State.all, id: :abbreviation, value: :abbreviation, display: :name
    end

    def aside_nav?
      true
    end

    def variations
      action_methods.sort
    end
    helper_method :variations
end
