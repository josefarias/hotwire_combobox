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

  # t=0     type "a", 150ms debounce starts
  # t=0.15  request A fires, q=a, stalled by the server until t=0.65
  # t=0.30  type "l" — A is out but unanswered — 150ms debounce restarts
  # t=0.45  request B fires, q=al, answered at once
  # t=0.65  A would land, after B
  # t=1.0   assert
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

  test "a superseded page can't trample the src that replaced it" do
    visit rescoped_async_path

    rescope_combobox "#movie-field", movies_path(starting_with: "Wh")
    open_combobox "#movie-field"

    assert_text "Whiplash"
    assert_no_text "Aladdin"
  end

  test "a page that lands after a selection can't mint it as new" do
    visit freetext_async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "few"
    assert_text "A Few Good Men"
    click_on_option "A Few Good Men"

    land_a_page_with_input_type "insertText", for_id: "movie-field"

    assert_combobox_display_and_value "#movie-field", "A Few Good Men", movies(:a_few_good_men).id
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :original
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
    def land_a_page_with_input_type(input_type, for_id:)
      page.execute_script <<~JS
        (() => {
          var listbox = document.getElementById("#{for_id}-hw-listbox")
          listbox.replaceChildren()

          var wrapper = document.createElement("li")
          wrapper.dataset.hwComboboxTarget = "endOfOptionsStream"
          wrapper.dataset.inputType = "#{input_type}"
          listbox.appendChild(wrapper)
        })()
      JS
    end

    def rescope_combobox(selector, src)
      page.execute_script <<~JS
        document.querySelector("#{selector}").closest("fieldset").dataset.hwComboboxAsyncSrcValue = "#{src}"
      JS
    end

    def while_the_stalled_response_is_still_in_flight
      sleep ComboboxesController::SLOW_ASYNC_LATENCY * 0.6
    end

    def once_the_stalled_response_would_have_landed
      sleep ComboboxesController::SLOW_ASYNC_LATENCY * 1.4
    end
end
