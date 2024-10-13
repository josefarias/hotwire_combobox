module ComboboxAssertionsHelper
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

  def locator_for(selector)
    # https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Matchers#has_field%3F-instance_method
    selector.delete_prefix("#")
  end
end
