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
      assert_text "isNewAndAllowed: <empty>"
      assert_text "isValid: true"
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

    assert_text "selections: 2."
    within "#selection" do
      assert_text "event: hw-combobox:selection"
      assert_text "value: <empty>"
      assert_text "display: <empty>"
      assert_text "query: <empty>"
      assert_text "fieldName: movie"
      assert_text "isNewAndAllowed: <empty>"
      assert_text "isValid: false"
    end

    open_combobox "#required"
    type_in_combobox "#required", "The Godfather"
    click_on_option "The Godfather Part II"
    open_combobox "#required"
    click_on_option "The Godfather Part III"

    within "#preselection" do
      assert_text "previousValue: #{movies(:the_godfather_part_ii).id}"
    end
    assert_text "preselections: 6."
    assert_text "selections: 4."
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

  private
    def selector_root(selector)
      "fieldset[data-controller~='hw-combobox']:has(#{selector})"
    end
end
