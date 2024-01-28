require "system_test_helper"

class HotwireComboboxTest < ApplicationSystemTestCase
  test "stimulus controllers from host app are loaded" do
    visit greeting_path
    assert_text "Hello there!"
  end

  test "combobox is rendered" do
    visit plain_combobox_path

    assert_selector "input[role=combobox]"
  end

  test "combobox is closed by default" do
    visit plain_combobox_path

    assert_selector "input[aria-expanded=false]"
    assert_no_selector "li"
  end

  test "combobox can be opened" do
    visit plain_combobox_path

    open_combobox

    assert_selector "input[aria-expanded=true]"
    assert_selector "ul[role=listbox]", id: "state-field-hw-listbox"
    assert_selector "li[role=option]", text: "Alabama"
  end

  test "combobox can be opened by default if configured that way" do
    visit open_combobox_path

    assert_selector "input[aria-expanded=true]"
    assert_selector "ul[role=listbox]", id: "state-field-hw-listbox"
    assert_selector "li[role=option]", text: "Alabama"
  end

  test "closing combobox by clicking outside" do
    visit plain_combobox_path

    open_combobox

    assert_selector "input[aria-expanded=true]"
    click_on_edge
    assert_selector "input[aria-expanded=false]"
    assert_no_selector "li"
  end

  test "closing combobox by focusing outside" do
    visit plain_combobox_path

    open_combobox

    assert_selector "input[aria-expanded=true]"
    find("body").send_keys(:tab)
    assert_selector "input[aria-expanded=false]"
    assert_no_selector "li"
  end

  test "options can contain html" do
    visit html_combobox_path

    open_combobox

    assert_selector "ul[role=listbox]", id: "state-field-hw-listbox"
    assert_selector "li[role=option] p", text: "Alabama"
  end

  test "options are filterable" do
    visit plain_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("Flo")
    assert_selector "li[role=option]", text: "Florida"
    assert_no_selector "li[role=option]", text: "Alabama"
  end

  test "autocompletion" do
    visit html_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("Flor")
    assert_field "state-field-hw-combobox", with: "Florida"
    assert_field "state-field", type: "hidden", with: "FL"
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Florida"

    find("#state-field-hw-combobox").send_keys(:backspace)
    assert_field "state-field-hw-combobox", with: "Flor"
    assert_field "state-field", type: "hidden", with: nil
    assert_no_selector "li[role=option].hw-combobox__option--selected"
  end

  test "autocomplete only works when strings match from the very beginning, but the first option is still selected" do
    visit html_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("lor")
    assert_field "state-field-hw-combobox", with: "lor"
    assert_field "state-field", type: "hidden", with: "FL"
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Florida"
  end

  test "pressing enter locks in the current selection, but editing the text field resets it" do
    visit html_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("lor", :enter)
    assert_selector "input[aria-expanded=false]"
    assert_field "state-field-hw-combobox", with: "Florida"
    assert_field "state-field", type: "hidden", with: "FL"
    assert_no_selector "li[role=option].hw-combobox__option--selected", text: "Florida" # because the list is closed

    find("#state-field-hw-combobox").send_keys(:backspace)
    assert_selector "input[aria-expanded=true]"
    assert_field "state-field-hw-combobox", with: "Florid"
    assert_field "state-field", type: "hidden", with: nil
    assert_no_selector "li[role=option].hw-combobox__option--selected"
  end

  test "clicking away locks in the current selection" do
    visit html_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("lor")
    click_on_edge
    assert_selector "input[aria-expanded=false]"
    assert_field "state-field-hw-combobox", with: "Florida"
    assert_field "state-field", type: "hidden", with: "FL"
  end

  test "focusing away locks in the current selection" do
    visit plain_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("lor")
    find("body").send_keys(:tab)
    assert_selector "input[aria-expanded=false]"
    assert_field "state-field-hw-combobox", with: "Florida"
    assert_field "state-field", type: "hidden", with: "FL"
  end

  test "navigating with the arrow keys" do
    visit html_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys(:down)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Alabama"

    find("#state-field-hw-combobox").send_keys(:down)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Florida"

    find("#state-field-hw-combobox").send_keys(:down)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Michigan"

    find("#state-field-hw-combobox").send_keys(:up)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Florida"

    find("#state-field-hw-combobox").send_keys(:up)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Alabama"

    # wrap around
    find("#state-field-hw-combobox").send_keys(:up)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Missouri"

    find("#state-field-hw-combobox").send_keys(:down)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Alabama"

    # home and end keys
    find("#state-field-hw-combobox").send_keys(:end)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Missouri"

    find("#state-field-hw-combobox").send_keys(:home)
    assert_selector "li[role=option].hw-combobox__option--selected", text: "Alabama"
  end

  test "select option by clicking on it" do
    visit html_combobox_path

    open_combobox

    assert_field "state-field-hw-combobox", with: nil
    assert_field "state-field", type: "hidden", with: nil

    find("li[role=option]", text: "Florida").click
    assert_selector "input[aria-expanded=false]"
    assert_field "state-field-hw-combobox", with: "Florida"
    assert_field "state-field", type: "hidden", with: "FL"
  end

  test "combobox with prefilled value" do
    visit prefilled_combobox_path

    assert_selector "input[aria-expanded=false]"
    assert_field "state-field-hw-combobox", with: "Michigan"
    assert_field "state-field", type: "hidden", with: "MI"

    open_combobox

    assert_selector "li[role=option].hw-combobox__option--selected", text: "Michigan"
  end

  test "combobox is invalid if required and empty" do
    visit required_combobox_path

    open_combobox

    assert_no_selector "input[aria-invalid=true]"
    find("#state-field-hw-combobox").send_keys("Flor", :backspace, :enter)
    assert_selector "input[aria-invalid=true]"
  end

  test "combobox is not invalid if empty but not required" do
    visit plain_combobox_path

    open_combobox

    assert_no_selector "input[aria-invalid=true]"
    find("#state-field-hw-combobox").send_keys("Flor", :backspace, :enter)
    assert_no_selector "input[aria-invalid=true]"
  end

  test "combobox is rendered when using the formbuilder" do
    visit formbuilder_combobox_path

    assert_selector "input[role=combobox]"
  end

  test "new options can be allowed" do
    assert_difference -> { State.count }, +1 do
      visit new_options_combobox_path

      find("#allow-new-hw-combobox").then do |combobox|
        combobox.click
        combobox.send_keys "Alaska", :enter
      end

      find("#disallow-new-hw-combobox").then do |combobox|
        combobox.click
        combobox.send_keys "Alabama", :enter
      end

      find("input[type=submit]").click

      assert_text "User created"
    end

    new_user = User.last
    assert_equal "Alaska", new_user.favorite_state.name
    assert_equal "Alabama", new_user.home_state.name
  end

  test "new options can be allowed when competing with an autocomplete suggestion" do
    assert_difference -> { State.count }, +1 do
      visit new_options_combobox_path

      find("#allow-new-hw-combobox").then do |combobox|
        combobox.click
        combobox.send_keys "Ala"

        assert_field "allow-new", type: "hidden", with: states(:al).id
        assert_selector "li[role=option][aria-selected=true]", text: "Alabama"
        assert_selector "input[name='user[favorite_state_id]']", visible: :hidden
        assert_no_selector "input[name='user[favorite_state_attributes][name]']", visible: :hidden

        combobox.send_keys :backspace
        assert_field "allow-new", type: "hidden", with: "Ala" # backspace removes the autocompleted part, not the typed part
        assert_no_selector "li[role=option][aria-selected=true]"
        assert_no_selector "input[name='user[favorite_state_id]']", visible: :hidden
        assert_selector "input[name='user[favorite_state_attributes][name]']", visible: :hidden

        combobox.send_keys :enter

        find("input[type=submit]").click
      end

      assert_text "User created"
    end

    new_user = User.last
    assert_equal "Ala", new_user.favorite_state.name
  end

  test "new options are sent blank when they're not allowed" do
    assert_no_difference -> { State.count } do
      visit new_options_combobox_path

      find("#disallow-new-hw-combobox").then do |combobox|
        combobox.click
        combobox.send_keys "Alaska", :enter
      end

      find("input[type=submit]").click

      assert_text "User created"
    end

    new_user = User.last
    assert_nil new_user.home_state
  end

  test "inline-only autocomplete" do
    visit inline_autocomplete_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("mi")
    assert_field "state-field", type: "hidden", with: "MI"
    find("#state-field-hw-combobox").send_keys(:down, :down)
    assert_field "state-field", type: "hidden", with: "MI"

    find("#state-field-hw-combobox").then do |input|
      "Michigan".chars.each { input.send_keys(:backspace) }
    end

    find("#state-field-hw-combobox").send_keys("mi")
    assert_field "state-field", type: "hidden", with: "MI"
    find("#state-field-hw-combobox").send_keys("n")
    assert_field "state-field", type: "hidden", with: "MN"
  end

  test "list-only autocomplete" do
    visit list_autocomplete_combobox_path

    open_combobox

    find("#state-field-hw-combobox").send_keys("mi")
    assert_field "state-field", type: "hidden", with: "MI"
    assert_field "state-field-hw-combobox", with: "mi"

    find("#state-field-hw-combobox").send_keys(:down, :down)
    assert_field "state-field", type: "hidden", with: "MS"
    assert_field "state-field-hw-combobox", with: "Mississippi"

    assert_selector "li[role=option]", text: "Michigan"
    assert_selector "li[role=option]", text: "Minnesota"
    assert_selector "li[role=option]", text: "Mississippi"
    assert_selector "li[role=option]", text: "Missouri"

    find("#state-field-hw-combobox").then do |input|
      "Mississippi".chars.each { input.send_keys(:backspace) }
    end

    find("#state-field-hw-combobox").send_keys("mi")

    click_on_edge

    assert_field "state-field", type: "hidden", with: "MI"
    assert_field "state-field-hw-combobox", with: "Michigan"
  end

  test "dialog" do
    on_small_screen do
      visit html_combobox_path

      assert_no_selector "dialog[open]"
      open_combobox
      assert_selector "dialog[open]"

      within "dialog" do
        find("#state-field-hw-dialog-combobox").send_keys("Flor")
        assert_field "state-field-hw-dialog-combobox", with: "Florida"
        assert_selector "li[role=option].hw-combobox__option--selected", text: "Florida"
      end

      click_on_edge
      assert_field "state-field", type: "hidden", with: "FL"
      assert_no_selector "dialog[open]"
    end
  end

  test "hw-combobox__listbox--empty class is added as needed" do
    visit plain_combobox_path

    open_combobox

    assert_no_selector "ul[role=listbox].hw-combobox__listbox--empty"

    find("#state-field-hw-combobox").then do |input|
      input.send_keys("asdf")
      assert_selector "ul[role=listbox].hw-combobox__listbox--empty"

      "asdf".chars.each { input.send_keys(:backspace) }

      input.send_keys("Flo")
      assert_no_selector "ul[role=listbox].hw-combobox__listbox--empty"
    end
  end

  [
    { path: :async_combobox_path, visible_options: 10 },
    { path: :async_html_combobox_path, visible_options: 5 }
  ].each do |test_case|
    test "async combobox #{test_case[:path]}" do
      visit send(test_case[:path])

      open_combobox "movie"

      find("#movie-field-hw-combobox").then do |input|
        assert_text "12 Angry Men"

        input.send_keys("wh")

        assert_field "movie-field-hw-combobox", with: "Whiplash"
        assert_selector "li[role=option]", count: 2

        input.send_keys(:backspace) # clear autocompleted portion
        "wh".chars.each { input.send_keys(:backspace) }

        assert_text "12 Angry Men"
      end

      find("#movie-field-hw-listbox").then do |listbox|
        assert_selector "li[role=option]", count: test_case[:visible_options]
        listbox.scroll_to :bottom
        assert_selector "li[role=option]", count: test_case[:visible_options] + 5
      end
    end
  end

  test "passing render_in to combobox_tag" do
    visit render_in_combobox_path

    open_combobox "movie"

    find("#movie-field-hw-combobox").send_keys("sn")
    assert_field "movie-field-hw-combobox", with: "Snow White and the Seven Dwarfs"
  end

  private
    def open_combobox(name = "state")
      find("##{name}-field-hw-combobox").click
    end

    def on_small_screen
      original_size = page.current_window.size
      page.current_window.resize_to 375, 667
      yield
    ensure
      page.current_window.resize_to *original_size
    end

    def click_on_edge
      page.execute_script("document.elementFromPoint(0, 0).click()")
    end
end
