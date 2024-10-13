require "system_test_helper"

class IncludeBlankTest < ApplicationSystemTestCase
  test "include_blank" do
    visit plain_path

    open_combobox "#state-field"
    assert_no_selector ".hw-combobox__option--blank"

    visit async_path

    open_combobox "#movie-field"
    assert_text "12 Angry Men" # wait for async filter
    assert_no_selector ".hw-combobox__option--blank"

    visit include_blank_path

    open_combobox "#literally-blank-field"
    assert_option_with class: ".hw-combobox__option--blank", text: " "
    type_in_combobox "#literally-blank-field", :down, :enter
    assert_combobox_display_and_value "#literally-blank-field", "", ""

    open_combobox "#movie-field"
    assert_option_with class: ".hw-combobox__option--blank", text: "All"
    type_in_combobox "#movie-field", "All"
    assert_option_with class: ".hw-combobox__option--blank", text: "All"
    assert_options_with count: 1 # All
    click_on_option "All"
    assert_combobox_display_and_value "#movie-field", "All", ""

    open_combobox "#html-movie-field"
    assert_option_with class: ".hw-combobox__option--blank", text: "All"
    type_in_combobox "#html-movie-field", "All"
    assert_option_with class: ".hw-combobox__option--blank", html_markup: "div > p", text: "All"
    assert_options_with count: 1 # All
    click_on_option "All"
    assert_combobox_display_and_value "#html-movie-field", "All", ""

    open_combobox "#state-field"
    assert_option_with class: ".hw-combobox__option--blank", text: "None"
    type_in_combobox "#state-field", "None"
    assert_option_with class: ".hw-combobox__option--blank", text: "None"
    assert_options_with count: 1 # None
    click_on_option "None"
    assert_combobox_display_and_value "#state-field", "None", ""
    assert_difference -> { User.count }, +1 do
      find("input[type=submit]").click
      assert_text "User created"
    end

    new_user = User.last
    assert_nil new_user.home_state
  end
end
