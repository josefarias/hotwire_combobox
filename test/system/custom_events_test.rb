require "system_test_helper"

class CustomEventsTest < ApplicationSystemTestCase
  test "custom events" do
    visit custom_events_path

    assert_text "Ready to listen for hw-combobox events!"

    assert_no_text "preselections:"

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Bea"

    assert_text "preselections: 1."
    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: #{movies(:a_beautiful_mind).id}"
      assert_text "display: A Beautiful Mind"
      assert_text "query: A Bea"
      assert_text "fieldName: movie"
      assert_text "isNewAndAllowed: false"
      assert_text "isValid: true"
      assert_text "previousValue: <empty>"
    end

    assert_no_text "event: hw-combobox:selection"

    type_in_combobox "#allow-new", "t"

    assert_text "preselections: 2."
    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: A Beat"
      assert_text "display: A Beat"
      assert_text "query: A Beat"
      assert_text "fieldName: new_movie"
      assert_text "isNewAndAllowed: true"
      assert_text "isValid: true"
      assert_text "previousValue: #{movies(:a_beautiful_mind).id}"
    end

    assert_no_text "event: hw-combobox:selection"

    click_away

    assert_text "selections: 1."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: A Beat"
      assert_text "display: A Beat"
      assert_text "query: A Beat"
      assert_text "fieldName: new_movie"
      assert_text "isNewAndAllowed: true"
      assert_text "isValid: true"
      assert_text "previousValue: <empty>"
    end

    open_combobox "#required"
    type_in_combobox "#required", "A Bea"

    assert_text "preselections: 3."
    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: #{movies(:a_beautiful_mind).id}"
      assert_text "display: A Beautiful Mind"
      assert_text "query: A Bea"
      assert_text "fieldName: movie"
      assert_text "isNewAndAllowed: false"
      assert_text "isValid: true"
      assert_text "previousValue: <empty>"
    end

    type_in_combobox "#required", "t"

    assert_text "preselections: 4."
    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: <empty>"
      assert_text "display: A Beat"
      assert_text "query: A Beat"
      assert_text "fieldName: movie"
      assert_text "isNewAndAllowed: false"
      assert_text "isValid: false"
      assert_text "previousValue: #{movies(:a_beautiful_mind).id}"
    end

    click_away

    # The committed value never changed (empty in, empty out), so no selection
    # fires — the previous selection ("A Beat") still stands.
    assert_text "selections: 1."
    within "#selection" do
      assert_text "value: A Beat"
    end

    open_combobox "#required"
    type_in_combobox "#required", "The Godfather"
    click_on_option "The Godfather Part II"
    open_combobox "#required"
    click_on_option "The Godfather Part III"

    within "#preselection" do
      assert_text "previousValue: #{movies(:the_godfather_part_ii).id}"
    end

    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: #{movies(:the_godfather_part_iii).id}"
      assert_text "isNewAndAllowed: false"
      assert_text "previousValue: #{movies(:the_godfather_part_ii).id}"
    end

    assert_text "preselections: 6."
    assert_text "selections: 3."
  end

  test "reopening and closing without changing the value does not fire a selection" do
    visit custom_events_path

    open_combobox "#required"
    type_in_combobox "#required", "The Godfather"
    click_on_option "The Godfather Part II"
    assert_text "selections: 1."

    open_combobox "#required"
    click_away
    assert_text "selections: 1."

    within "#selection" do
      assert_text "value: #{movies(:the_godfather_part_ii).id}"
      assert_text "previousValue: <empty>"
    end
  end

  test "preselection and selection events include chipData from option data-chip-* attrs" do
    visit custom_events_path

    open_combobox "#client-multiselect"
    click_on_option "Alabama"

    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: #{states(:alabama).id}"
      assert_text %(chipData: {"display":"Alabama","abbreviation":"AL","name_slug":"alabama"})
    end

    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: #{states(:alabama).id}"
      assert_text %(chipData: {"display":"Alabama","abbreviation":"AL","name_slug":"alabama"})
    end
  end

  test "chipData is empty for options without data-chip-* attrs" do
    visit custom_events_path

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Bea"

    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "chipData: <empty>"
    end
  end

  test "preselection event fires when clearing via the handle button" do
    visit custom_events_path

    open_combobox "#required"
    type_in_combobox "#required", "A Beautiful Mind"
    click_on_option "A Beautiful Mind"

    assert_text "preselections: 1."

    within "#preselection" do
      assert_text "value: #{movies(:a_beautiful_mind).id}"
    end

    within selector_root("#required") do
      find(".hw-combobox__handle").click
    end

    assert_text "preselections: 2."

    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: <empty>"
      assert_text "previousValue: #{movies(:a_beautiful_mind).id}"
    end
  end

  test "clearing reverts a brand-new value's field name back to the original" do
    visit custom_events_path

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Beat"

    within "#preselection" do
      assert_text "fieldName: new_movie"
    end

    within selector_root("#allow-new") do
      find(".hw-combobox__handle").click
    end

    within "#preselection" do
      assert_text "event: hw-combobox:preselection"
      assert_text "value: <empty>"
      assert_text "fieldName: movie"
      assert_text "previousValue: A Beat"
    end
  end

  test "clearing a value that was never committed still announces the selection" do
    visit custom_events_path

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Beat"
    within "#preselection" do
      assert_text "value: A Beat"
    end
    assert_no_text "event: hw-combobox:selection"

    within selector_root("#allow-new") do
      find(".hw-combobox__handle").click
    end

    assert_text "selections: 1."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: <empty>"
      assert_text "previousValue: A Beat"
    end
  end

  test "escape announces the selection it leaves committed" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#required"
    type_in_combobox "#required", "A Bea"
    assert_selected_option_with text: "A Beautiful Mind"
    assert_text "preselections: 1."
    assert_no_text "event: hw-combobox:selection"

    type_in_combobox "#required", :escape
    assert_closed_combobox

    assert_combobox_display_and_value "#required", "A Beautiful Mind", movies(:a_beautiful_mind).id
    assert_text "selections: 1."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: #{movies(:a_beautiful_mind).id}"
      assert_text "display: A Beautiful Mind"
      assert_text "previousValue: <empty>"
    end
  end

  test "escape announces a free text value it leaves committed" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Beat"
    assert_text "preselections: 1."
    assert_no_text "event: hw-combobox:selection"

    type_in_combobox "#allow-new", :escape
    assert_closed_combobox

    assert_combobox_display_and_value "#allow-new", "A Beat", "A Beat"
    assert_text "selections: 1."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: A Beat"
      assert_text "fieldName: new_movie"
      assert_text "isNewAndAllowed: true"
      assert_text "previousValue: <empty>"
    end
  end

  test "clearing announces the selection it removed" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#required"
    type_in_combobox "#required", "A Beautiful Mind"
    click_on_option "A Beautiful Mind"
    assert_text "selections: 1."

    within selector_root("#required") do
      find(".hw-combobox__handle").click
    end

    assert_text "selections: 2."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: <empty>"
      assert_text "previousValue: #{movies(:a_beautiful_mind).id}"
    end
  end

  test "clearing mid-session leaves the next selection reporting the value it really replaced" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#required"
    type_in_combobox "#required", "A Beautiful Mind"
    click_on_option "A Beautiful Mind"
    assert_text "selections: 1."

    open_combobox "#required"
    within selector_root("#required") do
      find(".hw-combobox__handle").click
    end
    assert_text "selections: 2."

    type_in_combobox "#required", "The Godfather Part II"
    click_on_option "The Godfather Part II"

    assert_text "selections: 3."
    within "#selection" do
      assert_text "value: #{movies(:the_godfather_part_ii).id}"
      assert_text "previousValue: <empty>"
    end
  end

  test "a second escape clears the combobox and announces that too" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#required"
    type_in_combobox "#required", "A Bea"
    assert_selected_option_with text: "A Beautiful Mind"
    type_in_combobox "#required", :escape
    assert_closed_combobox
    assert_text "selections: 1."

    send_keys :escape

    assert_combobox_display_and_value "#required", "", nil
    assert_text "selections: 2."
    within "#selection" do
      assert_text "value: <empty>"
      assert_text "previousValue: #{movies(:a_beautiful_mind).id}"
    end
  end

  test "escape on an unchanged combobox announces nothing" do
    visit custom_events_path
    assert_text "Ready to listen for hw-combobox events!"

    open_combobox "#required"
    type_in_combobox "#required", :escape
    assert_closed_combobox

    assert_no_text "event: hw-combobox:selection"
  end

  private
    def selector_root(selector)
      "fieldset[data-controller~='hw-combobox']:has(#{selector})"
    end
end
