require "system_test_helper"

# An async combobox prefilled with a value the src doesn't return (filtered out,
# or on a later page): opening it then clicking away must not change the value.
class PrefilledValueNotListedTest < ApplicationSystemTestCase
  test "keeps a prefilled value the filtered src doesn't list" do
    visit prefilled_async_value_not_listed_path

    assert_combobox_display_and_value "#filtered-home-state", "Florida", states(:florida).id

    open_combobox "#filtered-home-state"
    click_away

    assert_combobox_display_and_value "#filtered-home-state", "Florida", states(:florida).id
  end

  test "keeps a prefilled value that is not on the first page" do
    visit prefilled_async_value_not_listed_path

    assert_combobox_display_and_value "#paginated-home-state", "Florida", states(:florida).id

    open_combobox "#paginated-home-state"
    click_away

    assert_combobox_display_and_value "#paginated-home-state", "Florida", states(:florida).id
  end
end
