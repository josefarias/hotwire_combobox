module ComboboxActionsHelper
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

  def remove_chip(text)
    find("[aria-label='Remove #{text}']").click
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
