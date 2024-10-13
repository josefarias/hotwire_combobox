require "system_test_helper"

class DialogTest < ApplicationSystemTestCase
  test "dialog" do
    on_small_screen do
      visit async_html_path

      assert_no_selector "dialog[open]"
      open_combobox "#movie-field"
      assert_selector "dialog[open]"

      within "dialog" do
        type_in_combobox "#movie-field-hw-dialog-combobox", "whi"
        assert_combobox_display "#movie-field-hw-dialog-combobox", "Whiplash"
        assert_selected_option_with text: "Whiplash"
      end
      assert_combobox_value "#movie-field", movies(:whiplash).id

      click_away
      assert_combobox_display_and_value "#movie-field", "Whiplash", movies(:whiplash).id
      assert_no_selector "dialog[open]"
    end
  end

  test "selecting options within a dialog" do
    visit dialog_path

    click_on "Show modal"

    open_combobox "#movie_rating"
    click_on_option "R"
    assert_combobox_display_and_value "#movie_rating", "R", Movie.ratings[:R]
  end
end
