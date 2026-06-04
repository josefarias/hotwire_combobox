require "system_test_helper"

class ValidityTest < ApplicationSystemTestCase
  test "combobox is invalid if required and empty" do
    visit required_path

    open_combobox "#state-field"

    assert_not_invalid_combobox
    type_in_combobox "#state-field", "foobar", :enter
    assert_invalid_combobox
    assert_combobox_display_and_value "#state-field", nil, nil
  end

  test "combobox is not invalid if empty but not required" do
    visit plain_path

    open_combobox "#state-field"

    assert_not_invalid_combobox
    type_in_combobox "#state-field", "Flor", :backspace, :enter
    assert_not_invalid_combobox
  end

  test "required single select reflects the selected value, not the search input" do
    visit single_select_required_path

    assert_selector "input#empty-required-single[required]"
    assert_selector "input#prefilled-required-single:not([required])"

    open_combobox "#empty-required-single"
    click_on_option "Alabama"
    assert_selector "input#empty-required-single:not([required])"
  end

  test "required multiselect drops native required once it has chips" do
    visit multiselect_required_path

    assert_selector "input#empty-required-field[required]"
    assert_selector "input#prefilled-required-field:not([required])"

    open_combobox "#empty-required-field"
    click_on_option "Alabama"
    assert_chip_with text: "Alabama"
    assert_selector "input#empty-required-field:not([required])"
  end

  test "required multiselect restores native required when it loses all chips" do
    visit multiselect_required_path

    assert_selector "input#prefilled-required-field:not([required])"

    remove_chip "Alabama"
    assert_selector "input#prefilled-required-field[required]"
  end
end
