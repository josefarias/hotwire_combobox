require "system_test_helper"

class HotwireComboboxTest < ApplicationSystemTestCase
  test "combobox is rendered" do
    visit plain_path
    assert_combobox
  end

  test "combobox is closed by default" do
    visit plain_path

    assert_closed_combobox
    assert_no_visible_options
  end

  test "combobox can be opened" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with text: "Alabama"
  end

  test "combobox can be opened by default if configured that way" do
    visit open_path

    assert_open_combobox
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with text: "Alabama"
  end

  test "closing combobox by clicking outside" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox

    click_away
    assert_closed_combobox
    assert_no_visible_options
  end

  test "closing combobox by focusing outside" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox

    tab_away
    assert_closed_combobox
    assert_no_visible_options
  end

  test "label" do
    on_small_screen do
      visit async_html_path

      assert_text "Choose your movie!"

      open_combobox "#movie-field"

      within "dialog" do
        assert_text "Choose your movie!"
      end
    end
  end

  test "stimulus controllers from host app are loaded" do
    visit greeting_path
    assert_text "Hello there!"
  end

  test "options are filterable" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "Flo"
    assert_option_with text: "Florida"
    assert_no_visible_options_with text: "Alabama"
  end

  test "aria-activedescendant attribute" do
    visit async_path

    assert_selector "input[aria-activedescendant='']"
    assert_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox

    open_combobox "#movie-field"
    assert_text "12 Angry Men" # wait for async filter
    type_in_combobox "#movie-field", :down, :enter

    assert_selector "input[aria-activedescendant]" # attribute is present...
    assert_no_selector "input[aria-activedescendant='']" # ...but not empty
    assert_selector "input[aria-activedescendant]", visible: :hidden # dialog combobox
    assert_no_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", :backspace
    assert_selector "input[aria-activedescendant='']"
    assert_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox
  end

  test "combobox is rendered when using the formbuilder" do
    visit formbuilder_path
    assert_combobox
  end

  test "inline-only autocomplete" do
    visit inline_autocomplete_path

    open_combobox "#state-field"
    assert_no_listbox

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    type_in_combobox "#state-field", :down, :down
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"

    delete_from_combobox "#state-field", "Michigan", original: "Michigan"

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    type_in_combobox "#state-field", "n"
    assert_combobox_display_and_value "#state-field", "Minnesota", "MN"
  end

  test "list-only autocomplete" do
    visit list_autocomplete_path

    open_combobox "#state-field"
    assert_listbox

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "mi", "MI"

    type_in_combobox "#state-field", :down, :down
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"

    assert_option_with text: "Michigan"
    assert_option_with text: "Minnesota"
    assert_option_with text: "Mississippi"
    assert_option_with text: "Missouri"

    delete_from_combobox "#state-field", "Mississippi", original: "Mississippi"

    type_in_combobox "#state-field", "mi"

    click_away

    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
  end

  test "selection with conflicting order" do
    visit conflicting_order_path

    open_combobox "#conflicting-order"
    click_on_option "A"
    assert_combobox_display_and_value "#conflicting-order", "A", "A"
  end

  test "POROs as form objects" do
    visit form_object_path

    assert_combobox_display_and_value "#form_state_id", "Alabama", states(:alabama).id
  end

  test "selecting options within a modal dialog" do
    visit dialog_path

    click_on "Show modal"

    open_combobox "#movie_rating"
    click_on_option "R"
    assert_combobox_display_and_value "#movie_rating", "R", Movie.ratings[:R]
  end
end
