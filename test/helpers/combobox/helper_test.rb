require "test_helper"

class Combobox::HelperTest < ApplicationViewTestCase
  test "passing an input type" do
    assert_match /<input.* type="search".*/, combobox_tag(:foo, type: :search)
  end

  test "passing an id" do
    assert_match /<input.* id="foobar".*/, combobox_tag(:foo, id: :foobar)
  end

  test "passing a name" do
    assert_match /<input.* name="foo".*/, combobox_tag(:foo)
  end

  test "passing a form builder object" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    assert_match /<input.* id="foo_bar".* name="foo\[bar\]".*/, combobox_tag(:bar, form: form)
  end

  test "passing an id overrides form builder" do
    form = ActionView::Helpers::FormBuilder.new :foo, nil, self, {}
    assert_match /<input.* id="foobar".*/, combobox_tag(:bar, form: form, id: :foobar)
  end

  test "passing open" do
    assert_match /<div.* data-combobox-expanded-value="true".*/, combobox_tag(:foo, open: true)
  end
end
