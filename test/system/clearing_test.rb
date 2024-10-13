require "system_test_helper"

class ClearingTest < ApplicationSystemTestCase
  test "clear button" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    find(".hw-combobox__handle").click
    assert_combobox_display_and_value "#state-field", "", ""
  end

  test "clearing programmatically" do
    visit external_clear_path

    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    assert_combobox_display_and_value "#user_visited_state_ids",
      %w[ Florida Illinois ], states(:florida, :illinois).pluck(:id)

    find("#external_clear").click

    assert_combobox_display_and_value "#state-field", "", nil
    assert_combobox_display_and_value "#user_visited_state_ids", [], nil

    page.evaluate_script("document.activeElement.id") == "external_clear"
  end
end
