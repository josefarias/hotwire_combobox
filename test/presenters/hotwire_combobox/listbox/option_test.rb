require "test_helper"

class HotwireCombobox::Listbox::OptionTest < ApplicationViewTestCase
  test "passing option value, falls back to id" do
    option = view.hw_combobox_option id: 1, value: "foo"
    assert_attrs render(option), tag_name: :li, "data-value": "foo"

    option = view.hw_combobox_option id: 1
    assert_attrs render(option), tag_name: :li, "data-value": "1"
  end

  test "content falls back to display" do
    option = view.hw_combobox_option content: "foo"
    Nokogiri::HTML::DocumentFragment.parse(render(option)).tap do |fragment|
      assert_equal "foo", fragment.text
    end

    option = view.hw_combobox_option display: "bar"
    Nokogiri::HTML::DocumentFragment.parse(render(option)).tap do |fragment|
      assert_equal "bar", fragment.text
    end
  end

  test "filterable_as falls back to display" do
    option = view.hw_combobox_option filterable_as: "foo"
    assert_attrs render(option), tag_name: :li, "data-filterable-as": "foo"

    option = view.hw_combobox_option display: "bar"
    assert_attrs render(option), tag_name: :li, "data-filterable-as": "bar"
  end

  test "autocompletable_as falls back to display" do
    option = view.hw_combobox_option autocompletable_as: "foo"
    assert_attrs render(option), tag_name: :li, "data-autocompletable-as": "foo"

    option = view.hw_combobox_option display: "bar"
    assert_attrs render(option), tag_name: :li, "data-autocompletable-as": "bar"
  end

  private
    def render(option)
      view.render HotwireCombobox::Listbox::Option.new(option)
    end
end
