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
end
