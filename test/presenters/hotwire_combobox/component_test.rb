require "test_helper"

class HotwireCombobox::ComponentTest < ApplicationViewTestCase
  test "native html autocomplete is off by default" do
    HotwireCombobox::Component.new(view, :foo).tap do |component|
      assert_equal "off", component.input_attrs[:autocomplete].to_s
    end
  end

  test "native html autocomplete can be turned on" do
    HotwireCombobox::Component.new(view, :foo, input: { autocomplete: :on }).tap do |component|
      assert_equal "on", component.input_attrs[:autocomplete].to_s
    end
  end

  test "additional input actions can be added" do
    HotwireCombobox::Component.new(view, :foo, input: { data: { action: "click->other-controller#takeAction" } }).tap do |component|
      assert_match /focus->hw-combobox#open/, component.input_attrs[:data][:action].to_s       # make sure default actions are still present
      assert_match /click->other-controller#takeAction/, component.input_attrs[:data][:action].to_s  # see if additional action is present
    end
  end

  test "attributes can be customized" do
    component = HotwireCombobox::Component.new(view, "field-name", id: "id-string")
    component.customize_input class: "my-custom-class", data: { my_custom_attr: "value" }
    html = render component

    assert_attrs html, tag_name: :input, class: "hw-combobox__input my-custom-class"
    assert_attrs html, tag_name: :input, "data-my-custom-attr": "value"
  end

  test "protected attributes cannot be overridden" do
    component = HotwireCombobox::Component.new(view, "field-name", id: "id-string")
    component.customize_input id: "foo", name: "bar", role: "baz", value: "qux", aria: { haspopup: "foobar" }, data: { hw_combobox_target: "thud" }
    html = render component

    assert_attrs html, tag_name: :input, id: "id-string"
    assert_attrs html, tag_name: :input, name: "field-name"
    assert_attrs html, tag_name: :input, role: "combobox"
    assert_attrs html, tag_name: :input, "aria-haspopup": "listbox"
    assert_attrs html, tag_name: :input, "data-hw-combobox-target": "combobox"

    assert_no_attrs html, tag_name: :input, value: ""
  end

  test "dialog label is customizable" do
    component = HotwireCombobox::Component.new(view, "field-name", label: "Custom Label")

    assert_equal "Custom Label", component.label
    assert_equal "Custom Label", component.dialog_label

    component = HotwireCombobox::Component.new(view, "field-name", label: "Custom Label", dialog_label: "Dialog Label")

    assert_equal "Custom Label", component.label
    assert_equal "Dialog Label", component.dialog_label
  end
end
