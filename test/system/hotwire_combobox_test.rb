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
    assert_combobox_display_and_value "#state-field", "lor", "FL"
    assert_selected_option_with selector: ".hw-combobox__option--selected", text: "Florida"
  end

  focus
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

  test "pressing enter locks in the current selection, but editing the text field resets it" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is", :enter
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"
    assert_no_visible_selected_option # because the list is closed

    type_in_combobox "#state-field", :backspace
    assert_open_combobox
    assert_combobox_display_and_value "#state-field", "Mississipp", nil
    assert_no_visible_selected_option
  end

  test "clicking away locks in the current selection" do
    visit html_options_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is"
    click_away
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"

    open_combobox "#state-field"
    assert_options_with count: 1
  end

  test "focusing away locks in the current selection" do
    visit plain_path

    open_combobox "#state-field"
    type_in_combobox "#state-field", "is"
    tab_away
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Mississippi", "MS"

    open_combobox "#state-field"
    assert_options_with count: 1
  end

  test "navigating with the arrow keys" do
    visit html_options_path

    open_combobox "#state-field"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Florida"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Michigan"

    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Florida"

    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Alabama"

    # wrap around
    type_in_combobox "#state-field", :up
    assert_selected_option_with text: "Missouri"

    type_in_combobox "#state-field", :down
    assert_selected_option_with text: "Alabama"

    # home and end keys
    type_in_combobox "#state-field", :end
    assert_selected_option_with text: "Missouri"

    type_in_combobox "#state-field", :home
    assert_selected_option_with text: "Alabama"
  end

  test "select option by clicking on it" do
    visit html_options_path

    open_combobox "#state-field"
    assert_combobox_display_and_value "#state-field", nil, nil

    click_on_option "Florida"
    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Florida", "FL"

    open_combobox "#state-field"
    assert_options_with count: 1

    delete_from_combobox "#state-field", "Florida", original: "Florida"
    assert_options_with count: State.count
  end

  test "combobox with prefilled value" do
    visit prefilled_path

    assert_closed_combobox
    assert_combobox_display_and_value "#state-field", "Michigan", "MI"

    open_combobox "#state-field"
    assert_selected_option_with text: "Michigan"
  end

  test "combobox in form with prefilled value" do
    visit prefilled_form_path

    assert_closed_combobox
    assert_combobox_display_and_value "#user_favorite_state_id", "Michigan", states(:mi).id

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
    assert_combobox_display_and_value "#user_home_state_id", "Florida", states(:fl).id

    open_combobox "#user_home_state_id"
    assert_selected_option_with text: "Florida"
  end

  test "combobox is invalid if required and empty" do
    visit required_path

    open_combobox "#state-field"

    assert_not_invalid_combobox
    type_in_combobox "#state-field", "foobar", :enter
    assert_invalid_combobox
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
      type_in_combobox "#allow-new", "Alaska", :enter

      open_combobox "#disallow-new"
      type_in_combobox "#disallow-new", "Alabama", :enter

      find("input[type=submit]").click

      assert_text "User created"
    end

    new_user = User.last
    assert_equal "Alaska", new_user.favorite_state.name
    assert_equal "Alabama", new_user.home_state.name
  end

  test "new options can be allowed when competing with an autocomplete suggestion" do
    assert_difference -> { State.count }, +1 do
      visit new_options_path

      open_combobox "#allow-new"
      type_in_combobox "#allow-new", "Ala"
      assert_combobox_display_and_value "#allow-new", "Alabama", states(:al).id
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
      type_in_combobox "#disallow-new", "Alaska", :enter

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
    tab_away # ensure selection
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
    tab_away # ensure selection
    assert_combobox_display_and_value "#movie-field", "The Godfather Part II", movies(:the_godfather_part_ii).id
    assert_proper_combobox_name_choice original: :movie, new: :new_movie, proper: :original

    open_combobox "#movie-field"
    delete_from_combobox "#movie-field", " Part II", original: "The Godfather Part II"
    tab_away # ensure selection
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

  test "dialog" do
    on_small_screen do
      visit html_options_path

      assert_no_selector "dialog[open]"
      open_combobox "#state-field"
      assert_selector "dialog[open]"

      within "dialog" do
        type_in_combobox "#state-field-hw-dialog-combobox", "Flor"
        assert_combobox_display "#state-field-hw-dialog-combobox", "Florida"
        assert_selected_option_with text: "Florida"
      end
      assert_combobox_value "#state-field", "FL"

      click_away
      assert_combobox_display_and_value "#state-field", "Florida", "FL"
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
      find("li[role=option]", text: text).click
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
      assert_selector "li[role=option] #{html_markup}".squish, **kwargs
    end
    alias_method :assert_options_with, :assert_option_with

    def assert_combobox_display(selector, text)
      assert_field locator_for(selector), with: text
    end

    def assert_combobox_value(selector, value)
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
    end

    def assert_not_invalid_combobox
      assert_no_selector "input[aria-invalid=true]"
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
      page.current_window.resize_to *original_size
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
    end

    def click_away
      if @on_small_screen
        click_on_top_left_corner
      else
        find("#clickable").click
      end
    end

    def click_on_top_left_corner
      page.execute_script "document.elementFromPoint(0, 0).click()"
    end

    def current_selection_contents
      page.evaluate_script "document.getSelection().toString()"
    end
end
