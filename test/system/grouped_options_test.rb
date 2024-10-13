require "system_test_helper"

class GroupedOptionsTest < ApplicationSystemTestCase
  test "grouped options" do
    visit grouped_options_path

    open_combobox "#state-field"

    assert_group_with text: "South"
    assert_option_with text: "Alabama"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    open_combobox "#weird-state-field"
    assert_group_with text: "North America"
    assert_option_with text: "United States"

    type_in_combobox "#weird-state-field", :down
    assert_selected_option_with text: "United States"
    assert_combobox_display_and_value "#weird-state-field", "United States", "US"

    type_in_combobox "#weird-state-field", :down
    assert_selected_option_with text: "Canada"
    assert_combobox_display_and_value "#weird-state-field", "Canada", "Canada"

    open_combobox "#state-field-with-blank"
    assert_option_with class: ".hw-combobox__option--blank", text: "All"
    assert_group_with text: "South"
    assert_option_with text: "Alabama"

    type_in_combobox "#state-field-with-blank", :down
    assert_selected_option_with text: "All"
    type_in_combobox "#state-field-with-blank", :down
    assert_selected_option_with text: "Alabama"

    assert_combobox_display_and_value "#preselected", "Alabama", states(:alabama).id
    open_combobox "#preselected"
    assert_selected_option_with text: "Alabama"
  end
end
