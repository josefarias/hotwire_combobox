require "system_test_helper"

class RenderInTest < ApplicationSystemTestCase
  test "passing render_in to combobox_tag" do
    visit render_in_path

    open_combobox "#movie-field"

    assert_option_with html_markup: "div > p", text: "12 Angry Men"
    type_in_combobox "#movie-field", "sn"
    assert_combobox_display_and_value "#movie-field", "Snow White and the Seven Dwarfs", movies(:snow_white_and_the_seven_dwarfs).id
  end

  test "options can contain html" do
    visit html_options_path

    open_combobox "#state-field"
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with html_markup: "p", text: "Alabama"
  end

  test "render_in locals" do
    visit render_in_locals_path

    open_combobox "#state-field"
    assert_option_with text: "display: Alabama\nvalue: AL"
  end
end
