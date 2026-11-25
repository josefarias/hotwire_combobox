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

  test "a keystroke keeps the combobox pending through the answer to the query it replaced" do
    visit slow_async_long_debounce_path
    record_options_at_settle

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "a"
    assert_selector "body[data-requested-query='a']"
    type_in_combobox "#movie-field", "l"

    assert_selected_option_with text: "Aladdin"
    assert_no_selector "#movie-field[data-pending]"
    assert_equal [ %w[ Aladdin Alien Aliens ] ], options_at_settle
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

    def record_options_at_settle
      page.execute_script <<~JS
        window.HW_OPTIONS_AT_SETTLE = []
        document.addEventListener("hw-combobox:settled", () => {
          const options = document.querySelectorAll("#movie-field-hw-listbox [role=option]")
          window.HW_OPTIONS_AT_SETTLE.push([ ...options ].map(option => option.textContent.trim()))
        })

        const fetch = window.fetch
        window.fetch = (url, ...rest) => {
          document.body.dataset.requestedQuery = new URL(url, location.href).searchParams.get("q") ?? ""
          return fetch(url, ...rest)
        }
      JS
    end

    def options_at_settle
      Array(page.evaluate_script("window.HW_OPTIONS_AT_SETTLE"))
    end
end
