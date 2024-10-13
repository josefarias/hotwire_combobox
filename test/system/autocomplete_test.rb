require "system_test_helper"

class AutocompleteTest < ApplicationSystemTestCase
  test "autocompletion" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "Flor"
    assert_combobox_display_and_value "#state-field", "Florida", "FL"
    assert_selected_option_with selector: ".hw-combobox__option--selected", text: "Florida"

    type_in_combobox "#state-field", :backspace
    assert_combobox_display_and_value "#state-field", "Flor", nil
    assert_no_visible_selected_option
  end

  test "autocomplete with spaces in the query" do
    visit async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "12"
    type_in_combobox "#movie-field", " "
    sleep 0.5 # wait for async filter
    type_in_combobox "#movie-field", "ang", :enter
    sleep 0.5 # wait for async filter
    assert_combobox_display_and_value "#movie-field", "12 Angry Men", movies("12_angry_men").id
  end

  test "autocomplete only works when strings match from the very beginning, but the first option is still selected" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "lor"
    assert_combobox_display_and_value "#state-field", "lor", "CO"
    assert_selected_option_with selector: ".hw-combobox__option--selected", text: "Colorado"
  end
end
