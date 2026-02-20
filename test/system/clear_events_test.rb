require "system_test_helper"

class ClearEventsTest < ApplicationSystemTestCase
  test "clear events with partial text input" do
    visit clear_events_path

    type_in_combobox "#state-field", "Ala"
    find(".hw-combobox__handle").click

    assert_text "Clear Event #1"
    assert_text "Previous Display: \"Alabama\""
    assert_text "Field Name: \"state\""
    assert_text "Previous Value: \"AL\""
  end

  test "clear events with confirmed selection" do
    visit clear_events_path

    type_in_combobox "#state-field", "Alabama"
    click_away

    find(".hw-combobox__handle").click

    assert_text "Clear Event #1"
    assert_text "Previous Display: \"Alabama\""
    assert_text "Field Name: \"state\""
    assert_text "Previous Value: \"AL\""
  end
end
