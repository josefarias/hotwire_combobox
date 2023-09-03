require "system_test_helper"

class ComboboxTest < ApplicationSystemTestCase
  test "combobox is rendered" do
    visit root_path
    assert_selector "input[role=combobox]"
  end

  test "combobox is closed by default" do
    visit root_path
    assert_selector "input[aria-expanded=false]"
    assert_no_selector "li"
  end

  test "combobox can be opened" do
    visit root_path
    open_combobox
    assert_selector "input[aria-expanded=true]"
    assert_selector "ul[role=listbox]", id: "state-field-listbox"
    assert_selector "li[role=option]", text: "Alabama"
  end

  test "can be opened by default if configured that way" do
    visit open_combobox_path
    assert_selector "input[aria-expanded=true]"
    assert_selector "ul[role=listbox]", id: "state-field-listbox"
    assert_selector "li[role=option]", text: "Alabama"
  end

  test "options can contain html" do
    visit html_combobox_path
    open_combobox
    assert_selector "ul[role=listbox]", id: "state-field-listbox"
    assert_selector "li[role=option] p", text: "Alabama"
  end

  private
    def open_combobox
      find("input[role=combobox]").click
    end
end
