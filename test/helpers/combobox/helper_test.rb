require "test_helper"

class Combobox::HelperTest < ApplicationViewTestCase
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

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = combobox_tag :bar, form: form

    assert_attrs tag, id: "foo_bar", name: "foo[bar]"
  end

  test "passing an id overrides form builder" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    tag = combobox_tag :bar, form: form, id: :foobar

    assert_attrs tag, id: "foobar"
  end

  test "passing open" do
    tag = combobox_tag :foo, open: true

    assert_attrs tag, tag_name: :div, data_combobox_expanded_value: "true"
  end

  private
    def assert_attrs(tag, tag_name: :input, **attrs)
      attrs = attrs.map do |k, v|
        %Q(#{Regexp.escape(k).dasherize}="#{Regexp.escape(v)}".*)
      end.join(" ")

      assert_match /<#{tag_name}.* #{attrs}/, tag
    end
end
