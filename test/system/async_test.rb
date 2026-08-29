require "system_test_helper"

class AsyncTest < ApplicationSystemTestCase
  [
    { path: :async_path, visible_options: 10 },
    { path: :async_html_path, visible_options: 5 }
  ].each do |test_case|
    test "async combobox #{test_case[:path]}" do
      visit send(test_case[:path])

      open_combobox "#movie-field"

      assert_text "12 Angry Men"
      type_in_combobox "#movie-field", "wh"
      assert_combobox_display_and_value "#movie-field", "Whiplash", movies(:whiplash).id
      assert_options_with count: 2
      clear_autocompleted_portion "#movie-field"
      delete_from_combobox "#movie-field", "wh", original: "wh"
      assert_combobox_display_and_value "#movie-field", "", nil
      assert_text "12 Angry Men"

      # pagination
      assert_options_with count: test_case[:visible_options]
      find("#movie-field-hw-listbox").scroll_to :bottom
      assert_options_with count: test_case[:visible_options] + 5

      type_in_combobox "#movie-field", "a"
      assert_combobox_display_and_value "#movie-field", "A Beautiful Mind", movies(:a_beautiful_mind).id
      find("#movie-field-hw-listbox").scroll_to :bottom
      assert_options_with count: test_case[:visible_options] + 5
      assert_scrolled "#movie-field-hw-listbox"
    end
  end

  test "a superseded query can't trample the one that replaced it" do
    visit slow_async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "a"
    while_the_stalled_response_is_still_in_flight
    type_in_combobox "#movie-field", "l"
    once_the_stalled_response_would_have_landed

    assert_equal "addin", current_selection_contents
    assert_text "Aladdin"
    assert_no_text "12 Angry Men"
  end

  test "substring matching in async free-text combobox" do
    visit freetext_async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "few"
    click_on_option "A Few Good Men"
    assert_combobox_display_and_value "#movie-field", "A Few Good Men", movies(:a_few_good_men).id
  end

  test "preload" do
    visit async_preload_path
    assert_options_with count: 5, visible: :hidden
  end

  private
    def while_the_stalled_response_is_still_in_flight
      sleep ComboboxesController::SLOW_ASYNC_LATENCY * 0.6
    end

    def once_the_stalled_response_would_have_landed
      sleep ComboboxesController::SLOW_ASYNC_LATENCY * 1.4
    end
end
