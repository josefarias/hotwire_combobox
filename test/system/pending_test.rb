require "system_test_helper"

class PendingTest < ApplicationSystemTestCase
  test "an async filter is bracketed by pending and settled" do
    visit async_path
    record_pending_events

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "wh"
    assert_selected_option_with text: "Whiplash"
    assert_no_selector "#movie-field[data-pending]"

    assert_equal "pending", recorded_events.first
    assert_equal "settled", recorded_events.last
    assert_equal recorded_events.count("pending"), recorded_events.count("settled")
  end

  test "pending is announced from the keystroke, before the request goes out" do
    visit slow_async_path
    record_pending_events

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "a"

    assert_selector "#movie-field[data-pending]"
    assert_equal %w[ pending ], recorded_events
  end

  test "a sync combobox announces nothing" do
    visit plain_path
    record_pending_events

    open_combobox "#state-field"
    type_in_combobox "#state-field", "ari"
    assert_selected_option_with text: "Arizona"

    assert_empty recorded_events
    assert_no_selector "#state-field[data-pending]"
  end

  private
    def record_pending_events
      page.execute_script <<~JS
        window.HW_PENDING_EVENTS = []
        document.addEventListener("hw-combobox:pending", () => window.HW_PENDING_EVENTS.push("pending"))
        document.addEventListener("hw-combobox:settled", () => window.HW_PENDING_EVENTS.push("settled"))
      JS
    end

    def recorded_events
      Array(page.evaluate_script("window.HW_PENDING_EVENTS"))
    end
end
