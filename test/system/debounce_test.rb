require "system_test_helper"

class DebounceTest < ApplicationSystemTestCase
  test "setting the debounce attribute actually debounces" do
    visit debounced_path

    open_combobox "#movie-field"

    assert_text "12 Angry Men"
    type_in_combobox "#movie-field", "wh"

    sleep 0.100
    assert_text "12 Angry Men"

    sleep 0.500
    assert_no_text "12 Angry Men"
    assert_text "Whiplash"
    assert_options_with count: 2
    clear_autocompleted_portion "#movie-field"
    delete_from_combobox "#movie-field", "wh", original: "wh"
    assert_combobox_display_and_value "#movie-field", "", nil
    assert_text "12 Angry Men"
  end
end
