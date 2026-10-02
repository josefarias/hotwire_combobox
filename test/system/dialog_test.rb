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

  test "dialog dismissed from outside the combobox" do
    on_small_screen do
      visit async_html_path

      open_combobox "#movie-field"
      within "dialog" do
        type_in_combobox "#movie-field-hw-dialog-combobox", "whi"
        assert_selected_option_with text: "Whiplash"
      end

      page.execute_script "document.querySelector('dialog[open]').close()"
      assert_closed_combobox
      assert_combobox_display_and_value "#movie-field", "Whiplash", movies(:whiplash).id

      open_combobox "#movie-field"
      assert_selector "dialog[open]"
    end
  end

  test "no scrolling behind dialog" do
    # On mobile Safari — Manually test opening combobox, selecting, then re-opening.

    on_small_screen do
      visit padded_path

      title_element = find("#to-be-hidden-by-dialog")

      assert_in_viewport title_element
      page.scroll_to(find("#state-field"))
      assert_not_in_viewport title_element

      open_combobox "#state-field"
      assert_not_in_viewport title_element
    end
  end
end
