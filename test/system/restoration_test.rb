require "system_test_helper"

class RestorationTest < ApplicationSystemTestCase
  test "restores a single preloaded selection" do
    visit restoration_path

    assert_closed_combobox
    assert_combobox_display_and_value "#single-preloaded", "Michigan", "MI"

    open_combobox "#single-preloaded"
    assert_selected_option_with text: "Michigan"
  end

  test "restores a single async selection without loaded options" do
    visit restoration_path

    movie = Movie.first

    assert_closed_combobox
    assert_combobox_display_and_value "#single-async", movie.to_combobox_display, movie.id
  end

  test "restores a freetext new value" do
    visit restoration_path

    assert_combobox_display_and_value "#freetext", "Brand New Movie", "Brand New Movie"
    assert_proper_combobox_name_choice \
      original: "freetext_movie", new: "new_freetext_movie", proper: :new
  end

  test "restores a multiselect value as chips" do
    visit restoration_path

    assert_closed_combobox
    assert_combobox_display_and_value \
      "#multiselect",
      %w[ Florida Illinois ],
      states(:florida, :illinois).pluck(:id)

    open_combobox "#multiselect"
    assert_no_visible_options_with text: "Florida"
    assert_no_visible_options_with text: "Illinois"
  end

  test "restores a larger snapshot after removing a chip" do
    visit restoration_path

    assert_chip_with text: "Florida"
    assert_chip_with text: "Illinois"

    remove_chip "Florida"
    assert_no_selector "[data-hw-combobox-chip]", text: "Florida"
    click_away

    find("#restore-again").click

    assert_selector "[data-hw-combobox-chip]", text: "Florida", count: 1
    assert_selector "[data-hw-combobox-chip]", text: "Illinois", count: 1
    assert_combobox_value "#multiselect", states(:florida, :illinois).pluck(:id)
  end

  test "restore emits its own event but no preselection or selection events" do
    visit restoration_path

    # The restoration counter reaching the combobox count proves restores ran, so the
    # zeroed change-event counters mean restore stayed silent on the change channel.
    assert_text "restorations: 4."
    assert_text "preselections: 0."
    assert_text "selections: 0."
  end

  test "restoring twice does not duplicate chips" do
    visit restoration_path

    assert_selector "[data-hw-combobox-chip]", count: 2

    find("#restore-again").click

    assert_selector "[data-hw-combobox-chip]", count: 2
    assert_combobox_value "#multiselect", states(:florida, :illinois).pluck(:id)
  end
end
