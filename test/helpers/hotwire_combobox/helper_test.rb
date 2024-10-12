require "test_helper"
require "ostruct"

class HotwireCombobox::HelperTest < ApplicationViewTestCase
  test "passing an input type" do
    assert_attrs combobox_tag(:foo, type: :search), type: "search"
  end

  test "passing an id" do
    assert_attrs combobox_tag(:foo, id: :foobar), id: "foobar"
  end

  test "passing a name" do
    assert_attrs combobox_tag(:foo), name: "foo"
  end

  test "passing a value" do
    assert_attrs combobox_tag(:foo, value: :bar), value: "bar"
  end

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    assert_attrs combobox_tag(:bar, form: form), type: "hidden", name: "foo[bar]" # name is not "bar"
    assert_attrs combobox_tag(:bar, form: form), id: "foo_bar", role: "combobox" # id is determined by the form builder
  end

  test "passing a value overrides form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, OpenStruct.new(bar: "foobar"), self, {}
    assert_attrs combobox_tag(:bar, value: :baz, form: form), value: "baz" # not "foobar"
  end

  test "passing an id overrides form builder" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    assert_attrs combobox_tag(:bar, form: form, id: :foobar), id: "foobar" # not "foo_bar"
  end

  test "passing open" do
    assert_attrs combobox_tag(:foo, open: true), tag_name: :fieldset, "data-hw-combobox-expanded-value": "true"
  end

  test "a11y attributes" do
    assert_attrs combobox_tag(:foo, id: :foobar), role: "combobox",
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
    { alias: :paginated_combobox_options, method: :hw_paginated_combobox_options },
    { alias: :async_combobox_options, method: :hw_async_combobox_options }
  ].each do |pair|
    test "#{pair[:alias]} is an alias for #{pair[:method]}" do
      assert_equal HotwireCombobox::Helper.instance_method(pair[:method]), HotwireCombobox::Helper.instance_method(pair[:alias])
    end

    test "#{pair[:alias]} is not defined when bypassing convenience methods" do
      swap_config bypass_convenience_methods: true do
        assert_not HotwireCombobox::Helper.instance_methods.include?(pair[:alias]), "#{pair[:alias]} is defined"
      end
    end
  end

  test "hw_combobox_style_tag" do
    assert_attrs hw_combobox_style_tag, tag_name: :link, rel: "stylesheet", href: "/stylesheets/hotwire_combobox.css"
  end

  test "hw_listbox_id returns the same as component#listbox_id" do
    assert_instance_of String, hw_listbox_id(:bar)
    assert_equal hw_listbox_id(:bar), HotwireCombobox::Component.new(self, :foo, id: :bar).listbox_attrs[:id]
  end

  test "name_when_new must match original name on multiselects" do
    assert_raises ActiveModel::ValidationError do
      combobox_tag :foo, multiselect_chip_src: "some_path", name_when_new: :bar
    end

    assert_raises ActiveModel::ValidationError do
      form_with scope: :foo, url: "some_path" do |form|
        form.combobox :bar, multiselect_chip_src: "some_path", name_when_new: "foo[baz]"
      end
    end

    assert_nothing_raised do
      combobox_tag :foo, multiselect_chip_src: "some_path", name_when_new: :foo
      combobox_tag :foo, multiselect_chip_src: "some_path", free_text: true

      form_with scope: :foo, url: "some_path" do |form|
        form.combobox :bar, multiselect_chip_src: "some_path", name_when_new: "foo[bar]"
        form.combobox :bar, multiselect_chip_src: "some_path", free_text: true
      end
    end
  end

  test "free_text is a shortcut for name_when_new" do
    tag = combobox_tag :foo, free_text: true
    assert_attrs tag, tag_name: "fieldset", "data-hw-combobox-name-when-new-value": "foo"

    tag = combobox_tag :foo, free_text: true, name_when_new: nil
    assert_attrs tag, tag_name: "fieldset", "data-hw-combobox-name-when-new-value": "foo"

    tag = combobox_tag :foo, free_text: true, name_when_new: :bar
    assert_attrs tag, tag_name: "fieldset", "data-hw-combobox-name-when-new-value": "bar"

    tag = combobox_tag :foo, free_text: false, name_when_new: :bar
    assert_attrs tag, tag_name: "fieldset", "data-hw-combobox-name-when-new-value": "bar"

    tag = combobox_tag :foo, name_when_new: :bar
    assert_attrs tag, tag_name: "fieldset", "data-hw-combobox-name-when-new-value": "bar"
  end

  test "hw_paginated_combobox_options includes existing params in the default next page src, but excludes transient params" do
    request.expects(:path).returns("/foo")
    request.expects(:query_parameters).returns({ bar: "baz", qux: "quux", page: "1000", input_type: "insertText" }.with_indifferent_access)

    html = hw_paginated_combobox_options [], next_page: 2

    assert_attrs html, tag_name: "turbo-frame", src: "/foo?bar=baz&qux=quux&page=2&format=turbo_stream"
  end

  test "single repeating character values" do
    form = form_with model: OpenStruct.new(run_at: "* * * * *", persisted?: true, model_name: OpenStruct.new(param_key: :foo)), url: "#" do |form|
      form.combobox :run_at, [ "@hourly", "@daily", "@weekly", "@monthly", "@every 4h", "0 12 * * *" ], free_text: true
    end

    assert_equal "* * * * *", Nokogiri::HTML(form).css("input[name='foo[run_at]']").first.attr("value")
  end
end
