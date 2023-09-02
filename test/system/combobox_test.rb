require "system_test_helper"

class ComboboxTest < ApplicationSystemTestCase
  test "combobox is rendered" do
    visit root_path
    assert_selector "input[role=combobox]"
  end

  test "combobox is closed by default" do
    visit root_path
    assert_selector "input[aria-expanded=false]"
  end
end
