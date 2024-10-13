require "system_test_helper"

class PreselectionTest < ApplicationSystemTestCase
  test "combobox in form with prefilled value" do
    visit prefilled_form_path

    assert_closed_combobox
    assert_combobox_display_and_value "#user_favorite_state_id", "Michigan", states(:michigan).id

    open_combobox "#user_favorite_state_id"
    assert_selected_option_with text: "Michigan"
  end

  test "combobox with prefilled free text value" do
    visit prefilled_free_text_path

    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "East Oregon", "East Oregon"

    open_combobox "#state-field"
    assert_no_visible_selected_option
    assert_option_with text: "Oregon"
  end

  test "html combobox with prefilled value" do
    visit prefilled_html_path

    assert_closed_combobox
    assert_combobox_display_and_value "#movie-field", Movie.second.title, Movie.second.id

    open_combobox "#movie-field"
    assert_selected_option_with text: Movie.second.title
  end

  test "async combobox with prefilled value" do
    visit prefilled_async_path

    assert_closed_combobox
    assert_combobox_display_and_value "#user_home_state_id", "Florida", states(:florida).id

    open_combobox "#user_home_state_id"
    assert_selected_option_with text: "Florida"

    click_away

    assert_combobox_display_and_value "#movie_rating", Movie.first.rating, Movie.first.rating_before_type_cast
    open_combobox "#movie_rating"
    assert_selected_option_with text: Movie.first.rating
    click_away
    assert_combobox_display_and_value "#movie_rating", Movie.first.rating, Movie.first.rating_before_type_cast
  end

  test "combobox with prefilled value and working clear widget" do
    visit prefilled_path

    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    assert_selector ".hw-combobox__input[data-queried]"

    open_combobox "#state-field"
    assert_selected_option_with text: "Michigan"

    click_away
    find(".hw-combobox__handle").click
    assert_open_combobox
    assert_no_visible_selected_option

    click_away
    assert_no_selector ".hw-combobox__input[data-queried]"
  end

  test "preselected morph" do
    visit morph_path

    user = User.where.not(home_state: nil).first
    visited_states = user.visited_states
    new_home_state = State.all.without(user.home_state).first
    new_visited_state = State.all.without(visited_states).first

    assert_combobox_display_and_value "#user_home_state_id", user.home_state.name, user.home_state.id
    assert_combobox_display_and_value "#user_visited_state_ids", visited_states.map(&:name), visited_states.map(&:id)

    open_combobox "#user_home_state_id"
    click_on_option new_home_state.name
    assert_combobox_display_and_value "#user_home_state_id", new_home_state.name, new_home_state.id

    click_away

    open_combobox "#user_visited_state_ids"
    click_on_option new_visited_state.name
    assert_combobox_display_and_value "#user_visited_state_ids",
      (visited_states + [ new_visited_state ]).map(&:name),
      (visited_states + [ new_visited_state ]).map(&:id)

    assert_difference -> { user.visited_states.reload.size }, +1 do
      find("input[type=submit]").click
      assert_text "User updated"
    end

    assert_combobox_display_and_value "#user_home_state_id", new_home_state.name, new_home_state.id
    assert_combobox_display_and_value "#user_visited_state_ids",
      user.visited_states.map(&:name),
      user.visited_states.map(&:id)
  end
end
