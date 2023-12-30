require "test_helper"

class HotwireCombobox::HelperTest < ApplicationViewTestCase
  test "passing an input type" do
    tag = combobox_tag :foo, type: :search

    assert_attrs tag, type: "search"
  end

  test "passing an id" do
    tag = combobox_tag :foo, id: :foobar

    assert_attrs tag, id: "foobar"
  end

  test "passing a name" do
    tag = combobox_tag :foo

    assert_attrs tag, name: "foo"
  end

  test "passing a value" do
    tag = combobox_tag :foo, :bar

    assert_attrs tag, value: "bar"
  end

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = combobox_tag :bar, form: form

    assert_attrs tag, name: "foo[bar]", id: "foo_bar" # name is not "bar"
  end

  test "passing a form builder object overrides value" do
    form = ActionView::Helpers::FormBuilder.new :foo, OpenStruct.new(bar: "foobar"), self, {}
    tag = combobox_tag :bar, :baz, form: form

    assert_attrs tag, value: "foobar" # not "baz"
  end

  test "passing an id overrides form builder" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = combobox_tag :bar, form: form, id: :foobar

    assert_attrs tag, id: "foobar" # not "foo_bar"
  end

  test "passing open" do
    tag = combobox_tag :foo, open: true

    assert_attrs tag, tag_name: :fieldset, "data-hw-combobox-expanded-value": "true"
  end

  test "a11y attributes" do
    tag = combobox_tag :foo, id: :foobar

    assert_attrs tag, role: "combobox",
      "aria-controls": "foobar-hw-listbox", "aria-owns": "foobar-hw-listbox",
      "aria-haspopup": "listbox", "aria-autocomplete": "both"
  end

  test "hw_combobox_options instantiates an array of `HotwireCombobox::Option`s" do
    options = hw_combobox_options [
      { value: :foo, display: :bar },
      { value: :foobar, display: :barfoo }
    ]

    assert options.all? { |option| HotwireCombobox::Option === option }
  end

  test "passing an ActiveRecord::Relation to combobox_options" do
    options = combobox_options State.all, display: :name

    compliant = options.map.with_index do |option, i|
      HotwireCombobox::Option === option &&
        option.value == State.all[i].id &&
        option.display == State.all[i].name
    end.all?

    assert compliant
  end

  test "combobox_options is an alias for hw_combobox_options" do
    assert_equal \
      HotwireCombobox::Helper.instance_method(:hw_combobox_options),
      HotwireCombobox::Helper.instance_method(:combobox_options)
  end

  test "combobox_options is not defined when bypassing convenience methods" do
    swap_config bypass_convenience_methods: true do
      assert_not HotwireCombobox::Helper.instance_methods.include?(:combobox_options)
    end
  end

  test "combobox_tag is an alias for hw_combobox_tag" do
    assert_equal \
      HotwireCombobox::Helper.instance_method(:hw_combobox_tag),
      HotwireCombobox::Helper.instance_method(:combobox_tag)
  end

  test "combobox_tag is not defined when bypassing convenience methods" do
    swap_config bypass_convenience_methods: true do
      assert_not HotwireCombobox::Helper.instance_methods.include?(:combobox_tag)
    end
  end

  test "combobox is defined on the formbuilder" do
    assert ActionView::Helpers::FormBuilder.instance_methods.include?(:combobox)
  end
end
