require "test_helper"

class HotwireCombobox::HelperTest < ApplicationViewTestCase
  test "passing an input type" do
    tag = hw_combobox_tag :foo, type: :search

    assert_attrs tag, type: "search"
  end

  test "passing an id" do
    tag = hw_combobox_tag :foo, id: :foobar

    assert_attrs tag, id: "foobar"
  end

  test "passing a name" do
    tag = hw_combobox_tag :foo

    assert_attrs tag, name: "foo"
  end

  test "passing a value" do
    tag = hw_combobox_tag :foo, :bar

    assert_attrs tag, value: "bar"
  end

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = hw_combobox_tag :bar, form: form

    assert_attrs tag, name: "foo[bar]", id: "foo_bar" # name is not "bar"
  end

  test "passing a form builder object overrides value" do
    form = ActionView::Helpers::FormBuilder.new :foo, OpenStruct.new(bar: "foobar"), self, {}
    tag = hw_combobox_tag :bar, :baz, form: form

    assert_attrs tag, value: "foobar" # not "baz"
  end

  test "passing an id overrides form builder" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = hw_combobox_tag :bar, form: form, id: :foobar

    assert_attrs tag, id: "foobar" # not "foo_bar"
  end

  test "passing open" do
    tag = hw_combobox_tag :foo, open: true

    assert_attrs tag, tag_name: :fieldset, "data-hw-combobox-expanded-value": "true"
  end

  test "a11y attributes" do
    tag = hw_combobox_tag :foo, id: :foobar

    assert_attrs tag, role: "combobox",
      "aria-controls": "foobar-hw-listbox", "aria-owns": "foobar-hw-listbox",
      "aria-haspopup": "listbox", "aria-autocomplete": "both"
  end

  test "passing option value, falls back to id" do
    option = OpenStruct.new id: 1, value: "foo"
    assert_equal "foo", value_for_hw_listbox_option(option)

    option = OpenStruct.new id: 1
    assert_equal 1, value_for_hw_listbox_option(option)
  end

  private
    # `#assert_attrs` expects attrs to appear in the order they are passed.
    def assert_attrs(tag, tag_name: :input, **attrs)
      attrs = attrs.map do |k, v|
        %Q(#{escape(k)}="#{escape(v)}".*)
      end.join(" ")

      assert_match /<#{tag_name}.* #{attrs}/, tag
    end

    def escape(value)
      special_characters = Regexp.union "[]".chars
      value.to_s.gsub(special_characters) { |char| "\\#{char}" }
    end
end
