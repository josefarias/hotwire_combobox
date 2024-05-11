require "system_test_helper"

class HotwireComboboxTest < ApplicationSystemTestCase
  test "stimulus controllers from host app are loaded" do
    visit greeting_path
    assert_text "Hello there!"
  end

  test "combobox is rendered" do
    visit plain_path
    assert_combobox
  end

  test "combobox is closed by default" do
    visit plain_path

    assert_closed_combobox
    assert_no_visible_options
  end

  test "combobox can be opened" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with text: "Alabama"
  end

  test "combobox can be opened by default if configured that way" do
    visit open_path

    assert_open_combobox
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with text: "Alabama"
  end

  test "closing combobox by clicking outside" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox

    click_away
    assert_closed_combobox
    assert_no_visible_options
  end

  test "closing combobox by focusing outside" do
    visit plain_path

    open_combobox "#state-field"
    assert_open_combobox

    tab_away
    assert_closed_combobox
    assert_no_visible_options
  end

  test "options can contain html" do
    visit html_options_path

    open_combobox "#state-field"
    assert_listbox_with id: "state-field-hw-listbox"
    assert_option_with html_markup: "p", text: "Alabama"
  end

  test "options are filterable" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "Flo"
    assert_option_with text: "Florida"
    assert_no_visible_options_with text: "Alabama"
  end

  test "autocompletion" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "Flor"
    assert_combobox_display_and_value "#state-field", "Florida", "FL"
    assert_selected_option_with selector: ".hw-combobox__option--selected", text: "Florida"

    type_in_combobox "#state-field", :backspace
    assert_combobox_display_and_value "#state-field", "Flor", nil
    assert_no_visible_selected_option
  end

  test "autocomplete with spaces in the query" do
    visit async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "12"
    type_in_combobox "#movie-field", " "
    sleep 0.5 # wait for async filter
    type_in_combobox "#movie-field", "ang", :enter
    sleep 0.5 # wait for async filter
    assert_combobox_display_and_value "#movie-field", "12 Angry Men", movies("12_angry_men").id
  end

  test "autocomplete only works when strings match from the very beginning, but the first option is still selected" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "lor"
    assert_combobox_display_and_value "#state-field", "lor", "CO"
    assert_selected_option_with selector: ".hw-combobox__option--selected", text: "Colorado"
  end

  test "selecting with the keyboard" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "mi"
    type_in_combobox "#state-field", :down, :down
    assert_selected_option_with text: "Mississippi"

    type_in_combobox "#state-field", :enter
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"

    visit new_options_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "al"
    assert_text "Aliens" # wait for async filter
    type_in_combobox "#movie-field", :down, :down
    assert_selected_option_with text: "Aliens"
    type_in_combobox "#movie-field", :enter
    assert_combobox_display_and_value "#movie-field", "Aliens", movies(:aliens).id

    open_combobox "#movie-field"
    assert_options_with count: 1 # Aliens
  end

  test "aria-activedescendant attribute" do
    visit async_path

    assert_selector "input[aria-activedescendant='']"
    assert_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox

    open_combobox "#movie-field"
    assert_text "12 Angry Men" # wait for async filter
    type_in_combobox "#movie-field", :down, :enter

    assert_selector "input[aria-activedescendant]" # attribute is present...
    assert_no_selector "input[aria-activedescendant='']" # ...but not empty
    assert_selector "input[aria-activedescendant]", visible: :hidden # dialog combobox
    assert_no_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", :backspace
    assert_selector "input[aria-activedescendant='']"
    assert_selector "input[aria-activedescendant='']", visible: :hidden # dialog combobox
  end

  test "pressing enter locks in the current selection, but editing the text field resets it" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is", :enter
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Illinois", "IL"
    assert_no_visible_selected_option # because the list is closed

    type_in_combobox "#state-field", :backspace
    assert_open_combobox
    assert_combobox_display_and_value "#state-field", "Illinoi", nil
    assert_no_visible_selected_option
  end

  test "clicking away locks in the current selection" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is"
    click_away
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Illinois", "IL"

    open_combobox "#state-field"
    assert_options_with count: 1
  end

  test "focusing away locks in the current selection" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is"
    tab_away
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Illinois", "IL"

    open_combobox "#state-field"
    assert_options_with count: 1
  end

  test "navigating with the arrow keys" do
    visit html_options_path

    open_combobox "#state-field"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alaska"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Arizona"

    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Alaska"

    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Alabama"

    # wrap around
    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Wyoming"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    # home and end keys
    type_in_combobox "#state-field", :end
    assert_selected_option_with text: "Wyoming"

    type_in_combobox "#state-field", :home
    assert_selected_option_with text: "Alabama"
  end

  test "select option by clicking on it" do
    visit html_options_path

    open_combobox "#state-field"
    assert_combobox_display_and_value "#state-field", nil, nil

    click_on_option "Alaska"
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Alaska", "AK"

    open_combobox "#state-field"
    assert_options_with count: 1

    delete_from_combobox "#state-field", "Alaska", original: "Alaska"
    assert_options_with count: State.count

    type_in_combobox "#state-field", :down, :down, :down
    assert_selected_option_with text: "Arizona"
    click_on_option "Alabama"
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Alabama", "AL"
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

  test "combobox in form with prefilled value" do
    visit prefilled_form_path

    assert_closed_combobox
    assert_combobox_display_and_value "#user_favorite_state_id", "Michigan", states(:michigan).id

    open_combobox "#user_favorite_state_id"
    assert_selected_option_with text: "Michigan"
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

  test "combobox is invalid if required and empty" do
    visit required_path

    open_combobox "#state-field"

    assert_not_invalid_combobox
    type_in_combobox "#state-field", "foobar", :enter
    assert_invalid_combobox
    assert_combobox_display_and_value "#state-field", nil, nil
  end

  test "combobox is not invalid if empty but not required" do
    visit plain_path

    open_combobox "#state-field"

    assert_not_invalid_combobox
    type_in_combobox "#state-field", "Flor", :backspace, :enter
    assert_not_invalid_combobox
  end

  test "combobox is rendered when using the formbuilder" do
    visit formbuilder_path
    assert_combobox
  end

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

  test "inline-only autocomplete" do
    visit inline_autocomplete_path

    open_combobox "#state-field"
    assert_no_listbox

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    type_in_combobox "#state-field", :down, :down
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"

    delete_from_combobox "#state-field", "Michigan", original: "Michigan"

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    type_in_combobox "#state-field", "n"
    assert_combobox_display_and_value "#state-field", "Minnesota", "MN"
  end

  test "list-only autocomplete" do
    visit list_autocomplete_path

    open_combobox "#state-field"
    assert_listbox

    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "mi", "MI"

    type_in_combobox "#state-field", :down, :down
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"

    assert_option_with text: "Michigan"
    assert_option_with text: "Minnesota"
    assert_option_with text: "Mississippi"
    assert_option_with text: "Missouri"

    delete_from_combobox "#state-field", "Mississippi", original: "Mississippi"

    type_in_combobox "#state-field", "mi"

    click_away

    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
  end

  test "label" do
    on_small_screen do
      visit async_html_path

      assert_text "Choose your movie!"

      open_combobox "#movie-field"

      within "dialog" do
        assert_text "Choose your movie!"
      end
    end
  end

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

  [
    { path: :async_path, visible_options: 10 },
    { path: :async_html_path, visible_options: 5 }
  ].each do |test_case|
    test "async combobox #{test_case[:path]}" do
      visit send(test_case[:path])

      open_combobox "#movie-field"

      assert_text "12 Angry Men"
      type_in_combobox "#movie-field", "wh"
      assert_combobox_display_and_value "#movie-field", "Whiplash", movies(:whiplash).id
      assert_options_with count: 2
      clear_autocompleted_portion "#movie-field"
      delete_from_combobox "#movie-field", "wh", original: "wh"
      assert_combobox_display_and_value "#movie-field", "", nil
      assert_text "12 Angry Men"

      # pagination
      assert_options_with count: test_case[:visible_options]
      find("#movie-field-hw-listbox").scroll_to :bottom
      assert_options_with count: test_case[:visible_options] + 5

      type_in_combobox "#movie-field", "a"
      assert_combobox_display_and_value "#movie-field", "A Beautiful Mind", movies(:a_beautiful_mind).id
      find("#movie-field-hw-listbox").scroll_to :bottom
      assert_options_with count: test_case[:visible_options] + 5
      assert_scrolled "#movie-field-hw-listbox"
    end
  end

  test "passing render_in to combobox_tag" do
    visit render_in_path

    open_combobox "#movie-field"

    assert_option_with html_markup: "div > p", text: "12 Angry Men"
    type_in_combobox "#movie-field", "sn"
    assert_combobox_display_and_value "#movie-field", "Snow White and the Seven Dwarfs", movies(:snow_white_and_the_seven_dwarfs).id
  end

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

  test "async autocomplete selections don't trample over each other" do
    visit async_path

    on_slow_device delay: 0.5 do
      open_combobox "#movie-field"
      type_in_combobox "#movie-field", "a"
      sleep 0.3 # less than the delay, more than the debounce
      type_in_combobox "#movie-field", "l"
      sleep 0.7 # more than the delay

      assert_equal "addin", current_selection_contents
    end
  end

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

  test "custom events" do
    visit custom_events_path

    assert_text "Ready to listen for hw-combobox events!"

    assert_no_text "preselections:"

    open_combobox "#allow-new"
    type_in_combobox "#allow-new", "A Bea"

    assert_text "preselections: 1."
    assert_text "event: hw-combobox:preselection"
    assert_text "value: #{movies(:a_beautiful_mind).id}"
    assert_text "display: A Beautiful Mind"
    assert_text "query: A Bea"
    assert_text "fieldName: movie"
    assert_text "isNewAndAllowed: false"
    assert_text "isValid: true"
    assert_text "previousValue: <empty>"

    assert_no_text "event: hw-combobox:selection"

    type_in_combobox "#allow-new", "t"

    assert_text "preselections: 2."
    assert_text "event: hw-combobox:preselection"
    assert_text "value: A Beat"
    assert_text "display: A Beat"
    assert_text "query: A Beat"
    assert_text "fieldName: new_movie"
    assert_text "isNewAndAllowed: true"
    assert_text "isValid: true"
    assert_text "previousValue: #{movies(:a_beautiful_mind).id}"

    assert_no_text "event: hw-combobox:selection"

    click_away

    assert_text "selections: 1."
    assert_text "event: hw-combobox:selection"
    assert_text "value: A Beat"
    assert_text "display: A Beat"
    assert_text "query: A Beat"
    assert_text "fieldName: new_movie"
    assert_text "isNewAndAllowed: <empty>"
    assert_text "isValid: true"

    open_combobox "#required"
    type_in_combobox "#required", "A Bea"

    assert_text "preselections: 3."
    assert_text "event: hw-combobox:preselection"
    assert_text "value: #{movies(:a_beautiful_mind).id}"
    assert_text "display: A Beautiful Mind"
    assert_text "query: A Bea"
    assert_text "fieldName: movie"
    assert_text "isNewAndAllowed: false"
    assert_text "isValid: true"
    assert_text "previousValue: <empty>"

    type_in_combobox "#required", "t"

    assert_text "preselections: 4."
    assert_text "event: hw-combobox:preselection"
    assert_text "value: <empty>"
    assert_text "display: A Beat"
    assert_text "query: A Beat"
    assert_text "fieldName: movie"
    assert_text "isNewAndAllowed: false"
    assert_text "isValid: false"
    assert_text "previousValue: #{movies(:a_beautiful_mind).id}"

    click_away

    assert_text "selections: 2."
    assert_text "event: hw-combobox:selection"
    assert_text "value: <empty>"
    assert_text "display: A Beat"
    assert_text "query: A Beat"
    assert_text "fieldName: movie"
    assert_text "isNewAndAllowed: false"
    assert_text "isValid: false"

    open_combobox "#required"
    type_in_combobox "#required", "The Godfather"
    click_on_option "The Godfather Part II"
    open_combobox "#required"
    click_on_option "The Godfather Part III"

    assert_text "previousValue: #{movies(:the_godfather_part_ii).id}"
    assert_text "preselections: 6."
    assert_text "selections: 4."
  end

  test "customized elements" do
    visit custom_attrs_path

    assert_selector ".custom-class-for-form"
    assert_selector ".custom-class--fieldset"
    assert_selector ".custom-class--label"
    assert_selector ".custom-class--main_wrapper"
    assert_selector ".custom-class--icon"
    assert_selector ".custom-class--input"
    assert_selector ".custom-class--handle"
    assert_selector ".custom-class--hidden_field", visible: :hidden
    assert_selector ".custom-class--listbox", visible: :hidden
    assert_selector ".custom-class--dialog", visible: :hidden
    assert_selector ".custom-class--dialog_wrapper", visible: :hidden
    assert_selector ".custom-class--dialog_label", visible: :hidden
    assert_selector ".custom-class--dialog_input", visible: :hidden
    assert_selector ".custom-class--dialog_listbox", visible: :hidden

    assert_selector ".hw-combobox", count: 2
    assert_selector ".hw-combobox__label", count: 2
    assert_selector ".hw-combobox__main__wrapper", count: 2
    assert_selector ".hw-combobox__icon", count: 2
    assert_selector ".hw-combobox__input", count: 2
    assert_selector ".hw-combobox__handle", count: 2
    assert_selector ".hw-combobox__listbox", visible: :hidden, count: 2
    assert_selector ".hw-combobox__option", visible: :hidden
    assert_selector ".hw-combobox__dialog", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__wrapper", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__label", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__input", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__listbox", visible: :hidden, count: 2

    assert_selector "[data-custom-data-for-form]"
    assert_selector "[data-customized-fieldset]"
    assert_selector "[data-customized-label]"
    assert_selector "[data-customized-main-wrapper]"
    assert_selector "[data-customized-icon]"
    assert_selector "[data-customized-input]"
    assert_selector "[data-customized-handle]"
    assert_selector "[data-customized-hidden-field]", visible: :hidden
    assert_selector "[data-customized-listbox]", visible: :hidden
    assert_selector "[data-customized-dialog]", visible: :hidden
    assert_selector "[data-customized-dialog-wrapper]", visible: :hidden
    assert_selector "[data-customized-dialog-label]", visible: :hidden
    assert_selector "[data-customized-dialog-input]", visible: :hidden
    assert_selector "[data-customized-dialog-listbox]", visible: :hidden
  end

  test "clear button" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "mi"
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"
    find(".hw-combobox__handle").click
    assert_combobox_display_and_value "#state-field", "", ""
  end

  test "substring matching in async free-text combobox" do
    visit freetext_async_path

    open_combobox "#movie-field"
    type_in_combobox "#movie-field", "few"
    click_on_option "A Few Good Men"
    assert_combobox_display_and_value "#movie-field", "A Few Good Men", movies(:a_few_good_men).id
  end

  test "selection with conflicting order" do
    visit conflicting_order_path

    open_combobox "#conflicting-order"
    click_on_option "A"
    assert_combobox_display_and_value "#conflicting-order", "A", "A"
  end

  test "render_in locals" do
    visit render_in_locals_path

    open_combobox "#state-field"
    assert_option_with text: "display: Alabama\nvalue: AL"
  end

  test "multiselect" do
    visit multiselect_path

    open_combobox "#states-field"

    click_on_option "Alabama"
    assert_chip_with text: "Alabama" # wait for async chip creation
    click_on_option "California"
    assert_chip_with text: "California"
    click_on_option "Arizona"
    assert_chip_with text: "Arizona"
    assert_no_visible_options_with text: "Alabama"
    assert_no_visible_options_with text: "California"
    assert_no_visible_options_with text: "Arizona"
    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama California Arizona ],
      states(:alabama, :california, :arizona).pluck(:id)

    remove_chip "California"

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Arizona ],
      states(:alabama, :arizona).pluck(:id)

    open_combobox "#states-field"
    assert_option_with text: "California"
  end

  test "multiselect idiosyncrasies" do
    visit multiselect_path

    open_combobox "#states-field"
    assert_focused_combobox "#states-field"

    click_on_option "Alabama"
    assert_focused_combobox "#states-field"
    assert_chip_with text: "Alabama" # wait for async chip creation
    assert_no_visible_options_with text: "Alabama"
    type_in_combobox "#states-field", "ala"
    type_in_combobox "#states-field", :backspace # clear autocompleted portion
    assert_no_visible_options_with text: "Alabama"
    remove_chip "Alabama"
    assert_option_with text: "Alabama"

    click_on_option "Alabama"
    assert_chip_with text: "Alabama" # wait for async chip creation
    type_in_combobox "#states-field", "michi"
    assert_selected_option_with text: "Michigan"
    type_in_combobox "#states-field", :backspace # clear autocompleted portion
    assert_option_with text: "Michigan"
    remove_chip "Alabama"
    assert_no_visible_options_with text: "Alabama"
  end

  test "prefilled multiselect" do
    visit multiselect_async_html_path

    assert_closed_combobox
    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Alaska ],
      states(:alabama, :alaska).pluck(:id)
  end

  test "async multiselect" do
    visit multiselect_async_html_path

    open_combobox "#states-field"

    assert_option_with text: "Arizona"
    type_in_combobox "#states-field", "mi"
    assert_selected_option_with text: "Michigan"
    assert_options_with count: 4
    click_away
    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Alaska Michigan ],
      states(:alabama, :alaska, :michigan).pluck(:id)

    # pagination
    assert_options_with count: 8 # AL, AK, and MI are served but hidden
    find("#states-field-hw-listbox").scroll_to :bottom
    assert_options_with count: 13
  end

  test "html multiselect options and chips" do
    visit multiselect_async_html_path

    open_combobox "#states-field"

    assert_option_with html_markup: "div > p", text: "Arizona"
    assert_chip_with html_markup: "div > p", text: "Alabama"

    remove_chip "Alabama"

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alaska ],
      [ states(:alaska).id ]
  end

  test "multiselect form" do
    visit multiselect_prefilled_form_path

    assert_closed_combobox
    assert_combobox_display_and_value \
      "#user_visited_state_ids",
      %w[ Florida Illinois ],
      states(:florida, :illinois).pluck(:id)

    open_combobox "#user_visited_state_ids"
    type_in_combobox "#user_visited_state_ids", "Lou"
    click_on_option "Louisiana"
    assert_open_combobox
    assert_text "Alabama" # combobox is reset and still open

    assert_combobox_display_and_value \
      "#user_visited_state_ids",
      %w[ Florida Illinois Louisiana ],
      states(:florida, :illinois, :louisiana).pluck(:id)

    click_away
    find("input[type=submit]").click
    assert_text "User updated"

    assert_combobox_display_and_value \
      "#user_visited_state_ids",
      %w[ Florida Illinois Louisiana ],
      states(:florida, :illinois, :louisiana).pluck(:id)

    remove_chip "Florida"

    assert_combobox_display_and_value \
      "#user_visited_state_ids",
      %w[ Illinois Louisiana ],
      states(:illinois, :louisiana).pluck(:id)

    click_away
    find("input[type=submit]").click
    assert_text "User updated"

    assert_combobox_display_and_value \
      "#user_visited_state_ids",
      %w[ Illinois Louisiana ],
      states(:illinois, :louisiana).pluck(:id)
  end

  test "multiselect with dismissing streams" do
    visit multiselect_dismissing_path

    assert_closed_combobox

    open_combobox "#states-field"
    type_in_combobox "#states-field", "Lou"
    click_on_option "Louisiana"
    sleep 1
    assert_closed_combobox

    open_combobox "#async-states-field"
    type_in_combobox "#async-states-field", "Lou"
    click_on_option "Louisiana"
    sleep 1
    assert_closed_combobox
  end

  test "multiselect custom events" do
    visit multiselect_custom_events_path

    assert_text "Ready to listen for hw-combobox events!"
    assert_no_text "event: hw-combobox:preselection"
    assert_no_text "event: hw-combobox:selection"
    assert_no_text "preselections:"

    open_combobox "#states-field"
    type_in_combobox "#states-field", "mi"

    assert_text "event: hw-combobox:preselection"
    assert_text "value: #{states(:michigan).id}."
    assert_text "display: Michigan"
    assert_text "query: Mi"
    assert_text "fieldName: states"
    assert_text "isNewAndAllowed: false"
    assert_text "isValid: true"
    assert_text "previousValue: <empty>"
    assert_text "preselections: 2." # `m`, then `mi`
    assert_no_text "event: hw-combobox:selection"

    click_away
    assert_closed_combobox

    assert_text "event: hw-combobox:selection"
    assert_text "value: #{states(:michigan).id}."
    assert_text "display: Michigan"
    assert_text "query: Michigan"
    assert_text "fieldName: states"
    assert_text "isNewAndAllowed: <empty>"
    assert_text "isValid: true"
    assert_text "previousValue: <empty>"
    assert_text "selections: 1."

    assert_text "preselections: 3."

    remove_chip "Michigan"
    assert_open_combobox

    assert_text "removedDisplay: Michigan."
    assert_text "removedValue: #{states(:michigan).id}."
    assert_text "removals: 1."

    click_on_option "Arkansas"
    click_on_option "Colorado"

    assert_text "event: hw-combobox:preselection"
    assert_text "value: #{states(:arkansas, :colorado).pluck(:id).join(",")}."
    assert_text "display: Colorado."
    assert_text "query: Colorado."
    assert_text "fieldName: states."
    assert_text "isNewAndAllowed: false."
    assert_text "isValid: true."
    assert_text "previousValue: 1011954550."
    assert_text "removedDisplay: <empty>."
    assert_text "removedValue: <empty>."

    assert_text "event: hw-combobox:selection"
    assert_text "value: #{states(:arkansas, :colorado).pluck(:id).join(",")}."
    assert_text "display: Colorado."
    assert_text "query: Colorado."
    assert_text "fieldName: states."
    assert_text "isNewAndAllowed: <empty>."
    assert_text "isValid: true."
    assert_text "previousValue: <empty>."
    assert_text "removedDisplay: <empty>."
    assert_text "removedValue: <empty>."

    click_away

    assert_text "preselections: 7." # TODO: lockInSelection causes duplicate selection events; shouldn't lock-in unnecessarily
    assert_text "selections: 4."
  end

  test "navigating chips with keyboard" do
    visit multiselect_prefilled_form_path

    open_combobox "#user_visited_state_ids"
    assert_combobox_display "#user_visited_state_ids", %w[ Florida Illinois ]
    type_in_combobox "#user_visited_state_ids", :backspace, :enter
    assert_combobox_display "#user_visited_state_ids", %w[ Florida ]

    visit multiselect_prefilled_form_path

    open_combobox "#user_visited_state_ids"
    assert_combobox_display "#user_visited_state_ids", %w[ Florida Illinois ]
    type_in_combobox "#user_visited_state_ids", %i[shift tab], %i[shift tab], :enter
    assert_combobox_display "#user_visited_state_ids", %w[ Illinois ]
  end

  test "multiselect with new options" do
    visit multiselect_new_values_path

    open_combobox "#states-field"

    click_on_option "Alabama"
    assert_chip_with text: "Alabama"
    type_in_combobox "#states-field", "Newplace", :enter
    assert_chip_with text: "Newplace"

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Newplace ],
      [ states(:alabama).id, "Newplace" ]

    remove_chip "Newplace"
    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama ],
      [ states(:alabama).id ]

    type_in_combobox "#states-field", "New,place", :enter # comma is stripped away
    assert_chip_with text: "Newplace"
    click_away

    assert_combobox_display_and_value \
      "#states-field",
      %w[ Alabama Newplace ],
      [ states(:alabama).id, "Newplace" ]

    assert_difference -> { State.count }, +1 do
      find("input[type=submit]").click
      assert_text "Visits created"
    end

    assert_equal "Newplace", State.unscoped.last.name
    assert_equal %w[ Alabama Newplace ], User.first.visited_states.map(&:name)
  end

  test "grouped options" do
    visit grouped_options_path

    open_combobox "#state-field"

    assert_group_with text: "South"
    assert_option_with text: "Alabama"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    open_combobox "#weird-state-field"
    assert_group_with text: "North America"
    assert_option_with text: "United States"

    type_in_combobox "#weird-state-field", :down
    assert_selected_option_with text: "United States"
    assert_combobox_display_and_value "#weird-state-field", "United States", "US"

    type_in_combobox "#weird-state-field", :down
    assert_selected_option_with text: "Canada"
    assert_combobox_display_and_value "#weird-state-field", "Canada", "Canada"

    open_combobox "#state-field-with-blank"
    assert_option_with class: ".hw-combobox__option--blank", text: "All"
    assert_group_with text: "South"
    assert_option_with text: "Alabama"

    type_in_combobox "#state-field-with-blank", :down
    assert_selected_option_with text: "All"
    type_in_combobox "#state-field-with-blank", :down
    assert_selected_option_with text: "Alabama"

    assert_combobox_display_and_value "#preselected", "Alabama", states(:alabama).id
    open_combobox "#preselected"
    assert_selected_option_with text: "Alabama"
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

  test "POROs as form objects" do
    visit form_object_path

    assert_combobox_display_and_value "#form_state_id", "Alabama", states(:alabama).id
  end

  private
    def open_combobox(selector)
      find(selector).click
    end

    def type_in_combobox(selector, *text)
      find(selector).send_keys(*text)
    end

    def delete_from_combobox(selector, text, original:)
      find(selector).then do |input|
        original.chars.each { input.send_keys(:arrow_right) }
        text.chars.each { input.send_keys(:backspace) }
      end
    end

    def click_on_option(text)
      find("li[role=option]", exact_text: text).click
    end

    def clear_autocompleted_portion(selector)
      type_in_combobox selector, :backspace
    end

    def assert_combobox
      assert_selector "input[role=combobox]"
    end

    def assert_closed_combobox
      assert_selector "input[aria-expanded=false]"
    end

    def assert_open_combobox
      assert_selector "input[aria-expanded=true]"
    end

    def assert_no_listbox
      assert_no_selector "ul[role=listbox]"
    end

    def assert_listbox_with(**kwargs)
      assert_selector "ul[role=listbox]", **kwargs
    end
    alias_method :assert_listbox, :assert_listbox_with

    def assert_no_visible_options_with(**kwargs)
      assert_no_selector "li[role=option]", **kwargs
    end
    alias_method :assert_no_visible_options, :assert_no_visible_options_with

    def assert_option_with(html_markup: "", **kwargs)
      assert_selector "li[role=option]#{kwargs.delete(:class)} #{html_markup}".squish, **kwargs
    end
    alias_method :assert_options_with, :assert_option_with

    def assert_chip_with(html_markup: "", **kwargs)
      assert_selector "[data-hw-combobox-chip] #{html_markup}".squish, **kwargs
    end

    def assert_combobox_display(selector, text)
      if text.is_a? Array
        assert_selection_chips(*text)
      else
        assert_field locator_for(selector), with: text
      end
    end

    def assert_combobox_value(selector, value)
      value = value.join(",") if value.is_a? Array
      assert_field "#{locator_for(selector)}-hw-hidden-field", type: "hidden", with: value
    end

    def assert_combobox_display_and_value(selector, text, value)
      assert_combobox_display selector, text
      assert_combobox_value selector, value
    end

    def assert_selected_option_with(selector: "", **kwargs)
      assert_selector "li[role=option][aria-selected=true]#{selector}".squish, **kwargs
    end

    def assert_no_visible_selected_option
      assert_no_selector "li[role=option][aria-selected=true]"
    end

    def assert_invalid_combobox
      assert_selector "input[aria-invalid=true]"
      assert_selector "dialog input[aria-invalid=true]", visible: :hidden
    end

    def assert_not_invalid_combobox
      assert_no_selector "input[aria-invalid=true]"
      assert_no_selector "dialog input[aria-invalid=true]", visible: :hidden
    end

    def assert_proper_combobox_name_choice(original:, new:, proper:)
      if proper == :original
        assert_selector "input[name='#{original}']", visible: :hidden
        assert_no_selector "input[name='#{new}']", visible: :hidden
      else
        assert_no_selector "input[name='#{original}']", visible: :hidden
        assert_selector "input[name='#{new}']", visible: :hidden
      end
    end

    def assert_selection_chips(*texts)
      texts.each do |text|
        assert_selector "[data-hw-combobox-chip]", text: text
      end
    end

    def assert_focused_combobox(selector)
      page.evaluate_script("document.activeElement.id") == locator_for(selector)
    end

    def assert_group_with(**kwargs)
      assert_selector "ul[role=group] li[role=presentation]", **kwargs
    end

    def assert_scrolled(selector)
      sleep 0.5
      assert page.evaluate_script("document.querySelector('#{selector}').scrollTop") > 0,
        "Expected #{selector} to be scrolled."
    end

    def remove_chip(text)
      find("[aria-label='Remove #{text}']").click
    end

    def locator_for(selector)
      # https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Matchers#has_field%3F-instance_method
      selector.delete_prefix("#")
    end

    def on_small_screen
      @on_small_screen = true
      original_size = page.current_window.size
      page.current_window.resize_to 375, 667
      yield
    ensure
      @on_small_screen = false
      page.current_window.resize_to(*original_size)
    end

    def on_slow_device(delay:)
      @on_slow_device = true
      page.execute_script "window.HOTWIRE_COMBOBOX_STREAM_DELAY = #{delay * 1000}"
      yield
    ensure
      @on_slow_device = false
      page.execute_script "window.HOTWIRE_COMBOBOX_STREAM_DELAY = 0"
    end

    def tab_away
      find("body").send_keys(:tab, :tab)
      assert_closed_combobox
    end

    def click_away
      if @on_small_screen
        click_on_top_left_corner
      else
        find("#clickable").click
      end

      assert_closed_combobox
    end

    def click_on_top_left_corner
      page.execute_script "document.elementFromPoint(0, 0).click()"
    end

    def current_selection_contents
      page.evaluate_script "document.getSelection().toString()"
    end
end
