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
    tag = combobox_tag :foo, value: :bar

    assert_attrs tag, value: "bar"
  end

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = combobox_tag :bar, form: form

    assert_attrs tag, type: "hidden", name: "foo[bar]" # name is not "bar"
    assert_attrs tag, id: "foo_bar", role: "combobox" # id is determined by the form builder
  end

  test "passing a form builder object overrides value" do
    form = ActionView::Helpers::FormBuilder.new :foo, OpenStruct.new(bar: "foobar"), self, {}
    tag = combobox_tag :bar, value: :baz, form: form

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

  test "hw_combobox_options instantiates an array of `HotwireCombobox::Listbox::Option`s" do
    options = hw_combobox_options [
      { value: :foo, display: :bar },
      { value: :foobar, display: :barfoo }
    ]

    assert options.all? { |option| HotwireCombobox::Listbox::Option === option }
  end

  test "passing an ActiveRecord::Relation to combobox_options" do
    options = combobox_options State.all, display: :name

    options.map.with_index do |option, i|
      assert_instance_of HotwireCombobox::Listbox::Option, option
      assert_equal State.all[i].id, option.send(:value)
      assert_equal State.all[i].name, option.send(:content)
    end
  end

  [
    { alias: :combobox_style_tag, method: :hw_combobox_style_tag },
    { alias: :combobox_tag, method: :hw_combobox_tag },
    { alias: :combobox_options, method: :hw_combobox_options },
    { alias: :paginated_combobox_options, method: :hw_paginated_combobox_options }
  ].each do |pair|
    test "#{pair[:alias]} is an alias for #{pair[:method]}" do
      assert_equal \
        HotwireCombobox::Helper.instance_method(pair[:method]),
        HotwireCombobox::Helper.instance_method(pair[:alias])
    end

    test "#{pair[:alias]} is not defined when bypassing convenience methods" do
      swap_config bypass_convenience_methods: true do
        assert_not HotwireCombobox::Helper.instance_methods.include?(pair[:alias]),
          "#{pair[:alias]} is defined"
      end
    end
  end

  test "hw_combobox_style_tag" do
    assert_attrs hw_combobox_style_tag, tag_name: :link,
      rel: "stylesheet", href: "/stylesheets/hotwire_combobox.css"
  end

  test "hw_listbox_options_id returns the same as component#listbox_options_id" do
    assert_instance_of String, hw_listbox_options_id(:bar)
    assert_equal hw_listbox_options_id(:bar), HotwireCombobox::Component.new(self, :foo, id: :bar).listbox_options_attrs[:id]
  end
end
