require "system_test_helper"

class EnumTest < ApplicationSystemTestCase
  test "enum combobox" do
    Movie.update_all rating: :PG

    visit enum_path

    assert_combobox_display_and_value "#movie_rating", "PG", Movie.ratings[:PG]

    open_combobox "#rating-enum"
    click_on_option "R"
    assert_combobox_display_and_value "#rating-enum", "R", Movie.ratings[:R]

    open_combobox "#rating-enum-html"
    assert_option_with html_markup: "p", text: Movie.ratings.keys.first
    click_away

    open_combobox "#rating-keys"
    click_on_option "PG-13"
    assert_combobox_display_and_value "#rating-keys", "PG-13", "PG-13"

    open_combobox "#rating-keys-html"
    assert_option_with html_markup: "p", text: Movie.ratings.keys.first
    click_away
  end
end
