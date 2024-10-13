require "system_test_helper"

class FreetextTest < ApplicationSystemTestCase
  test "new options can be allowed" do
    assert_difference -> { State.count }, +1 do
      visit new_options_path

      open_combobox "#allow-new"
      type_in_combobox "#allow-new", "Newplace", :enter

      open_combobox "#disallow-new"
      type_in_combobox "#disallow-new", "Alabama", :enter

      find("input[type=submit]").click

      assert_text "User created"
    end

    new_user = User.last
    assert_equal "Newplace", new_user.favorite_state.name
    assert_equal "Alabama", new_user.home_state.name
  end

  test "new options can be allowed when competing with an autocomplete suggestion" do
    assert_difference -> { State.count }, +1 do
      visit new_options_path

      open_combobox "#allow-new"
      type_in_combobox "#allow-new", "Ala"
      assert_combobox_display_and_value "#allow-new", "Alabama", states(:alabama).id
      assert_selected_option_with text: "Alabama"
      assert_proper_combobox_name_choice \
        original: "user[favorite_state_id]",
        new: "user[favorite_state_attributes][name]",
        proper: :original

      type_in_combobox "#allow-new", :backspace
      assert_combobox_display_and_value "#allow-new", "Ala", "Ala" # backspace removes the autocompleted part, not the typed part
      assert_no_visible_selected_option
      assert_proper_combobox_name_choice \
        original: "user[favorite_state_id]",
        new: "user[favorite_state_attributes][name]",
        proper: :new

      type_in_combobox "#allow-new", :enter
      find("input[type=submit]").click
      assert_text "User created"
    end

    new_user = User.last
    assert_equal "Ala", new_user.favorite_state.name
  end

  test "new options are sent blank when they're not allowed" do
    assert_no_difference -> { State.count } do
      visit new_options_path

      open_combobox "#disallow-new"
      type_in_combobox "#disallow-new", "Newplace", :enter

      find("input[type=submit]").click

      assert_text "User created"
    end

    new_user = User.last
    assert_nil new_user.home_state
  end

  test "going back and forth between new and existing options" do
    visit new_options_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "The Godfather"
    assert_text "The Godfather Part II" # wait for async filter
    clear_autocompleted_portion "#movie-field"
    tab_away # lock-in selection
    assert_combobox_display_and_value "#movie-field", "The Godfather", "The Godfather"
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :new

    open_combobox "#movie-field"
    assert_options_with count: 2 # Parts II and III
    click_on_option "The Godfather Part III"
    assert_combobox_display_and_value "#movie-field", "The Godfather Part III", movies(:the_godfather_part_iii).id
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :original

    open_combobox "#movie-field"
    assert_options_with count: 1 # Part III
    delete_from_combobox "#movie-field", "I", original: "The Godfather Part III"
    assert_options_with count: 2 # Parts II and III
    tab_away # lock-in selection
    assert_combobox_display_and_value "#movie-field", "The Godfather Part II", movies(:the_godfather_part_ii).id
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :original

    open_combobox "#movie-field"
    delete_from_combobox "#movie-field", " Part II", original: "The Godfather Part II"
    tab_away # lock-in selection
    assert_combobox_display_and_value "#movie-field", "The Godfather", "The Godfather"
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :new
  end
end
