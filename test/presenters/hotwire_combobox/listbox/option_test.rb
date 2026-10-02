require "test_helper"

class HotwireCombobox::Listbox::OptionTest < ApplicationViewTestCase
  test "passing option value, falls back to id" do
    option = { id: 1, value: "foo" }
    assert_attrs render(option), tag_name: :li, "data-value": "foo"

    option = { id: 1 }
    assert_attrs render(option), tag_name: :li, "data-value": "1"
  end

  test "content falls back to display" do
    option = { content: "foo" }
    Nokogiri::HTML::DocumentFragment.parse(render(option)).tap do |fragment|
      assert_equal "foo", fragment.text
    end

    option = { display: "bar" }
    Nokogiri::HTML::DocumentFragment.parse(render(option)).tap do |fragment|
      assert_equal "bar", fragment.text
    end
  end

  test "filterable_as falls back to display" do
    option = { filterable_as: "foo" }
    assert_attrs render(option), tag_name: :li, "data-filterable-as": "foo"

    option = { display: "bar" }
    assert_attrs render(option), tag_name: :li, "data-filterable-as": "bar"
  end

  test "autocompletable_as falls back to display" do
    option = { autocompletable_as: "foo" }
    assert_attrs render(option), tag_name: :li, "data-autocompletable-as": "foo"

    option = { display: "bar" }
    assert_attrs render(option), tag_name: :li, "data-autocompletable-as": "bar"
  end

  test "chip_data renders as data-chip-* attributes on the option" do
    option = { chip_data: { display: "Alabama", abbreviation: "AL", name_slug: "alabama" } }
    html = render(option)

    assert_attrs html, tag_name: :li, "data-chip-display": "Alabama"
    assert_attrs html, tag_name: :li, "data-chip-abbreviation": "AL"
    assert_attrs html, tag_name: :li, "data-chip-name-slug": "alabama"
  end

  test "no data-chip-* attributes appear when chip_data is absent" do
    assert_no_match "data-chip-", render(display: "Alabama")
  end

  private
    def render(option)
      view.render HotwireCombobox::Listbox::Option.new(option)
    end
end
