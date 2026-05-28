require "system_test_helper"

class MultiselectClientTest < ApplicationSystemTestCase
  test "renders chips client-side from a chip_template + chip_attributes" do
    visit multiselect_client_path

    open_combobox "#states-field"
    click_on_option "Alabama"
    assert_closed_combobox
    assert_chip_with html_markup: "div.custom-chip > p", text: "Alabama"
    assert_chip_with html_markup: "span.state.state--alabama", visible: :all
    assert_chip_with html_markup: "small[data-abbr='AL']", visible: :all

    open_combobox "#states-field"
    click_on_option "California"
    assert_chip_with html_markup: "div.custom-chip > p", text: "California"
    assert_chip_with html_markup: "span.state.state--california", visible: :all
    assert_chip_with html_markup: "small[data-abbr='CA']", visible: :all

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama California ],
      states(:alabama, :california).pluck(:id)

    open_combobox "#states-field"
    assert_no_visible_options_with text: "Alabama"
    assert_no_visible_options_with text: "California"

    remove_chip "California"
    assert_option_with text: "California"
    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama ],
      [ states(:alabama).id ]
  end

  test "options carry data-chip-* attributes derived from chip_attributes" do
    visit multiselect_client_path

    open_combobox "#states-field"

    assert_selector "li[role=option][data-chip-display='Alabama'][data-chip-abbreviation='AL'][data-chip-name-slug='alabama']"
  end

  test "chip template element is present inside the fieldset" do
    visit multiselect_client_path

    assert_selector "fieldset.hw-combobox--multiple template[data-hw-combobox-chip-template]", visible: false
  end

  test "renders chips from a prefilled value on connect" do
    visit multiselect_client_prefilled_path

    assert_closed_combobox
    assert_combobox_value "#states-field", states(:alabama, :california).pluck(:id)

    assert_chip_with html_markup: "div.custom-chip > p", text: "Alabama"
    assert_chip_with html_markup: "div.custom-chip > p", text: "California"
    assert_chip_with html_markup: "span.state.state--alabama", visible: :all
    assert_chip_with html_markup: "span.state.state--california", visible: :all

    open_combobox "#states-field"
    assert_no_visible_options_with text: "Alabama"
    assert_no_visible_options_with text: "California"
  end

  test "renders prefilled chips from prefilled_chips_attributes when listbox is async" do
    visit multiselect_client_async_prefilled_path

    assert_closed_combobox
    assert_combobox_value "#states-field", states(:alabama, :california).pluck(:id)

    assert_chip_with html_markup: "div.custom-chip > p", text: "Alabama"
    assert_chip_with html_markup: "div.custom-chip > p", text: "California"
    assert_chip_with html_markup: "small[data-abbr='AL']", visible: :all
    assert_chip_with html_markup: "small[data-abbr='CA']", visible: :all
    assert_chip_with html_markup: "span.state.state--alabama", visible: :all
    assert_chip_with html_markup: "span.state.state--california", visible: :all
  end

  test "renders client-side chips for free-text new values" do
    visit multiselect_client_new_values_path

    open_combobox "#states-field"
    click_on_option "Alabama"
    assert_chip_with html_markup: "div.simple-chip > span.simple-chip__display", text: "Alabama"

    type_in_combobox "#states-field", "Newplace", :enter
    assert_chip_with html_markup: "div.simple-chip > span.simple-chip__display", text: "Newplace"
    # Confirms placeholder substitution ran on the chip remover even though
    # "Newplace" has no matching listbox option (display falls back to the value).
    assert_selector "[data-hw-combobox-chip] [aria-label='Remove Newplace']", visible: :all

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Newplace ],
      [ states(:alabama).id, "Newplace" ]
  end
end
