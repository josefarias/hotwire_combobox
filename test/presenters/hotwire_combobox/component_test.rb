require "test_helper"

class HotwireCombobox::ComponentTest < ApplicationViewTestCase
  test "native html autocomplete is off by default" do
    HotwireCombobox::Component.new(view, :foo).tap do |component|
      assert_equal :off, component.input_attrs[:autocomplete]
    end
  end

  test "native html autocomplete can be turned on" do
    HotwireCombobox::Component.new(view, :foo, input: { autocomplete: :on }).tap do |component|
      assert_equal :on, component.input_attrs[:autocomplete]
    end
  end
end
