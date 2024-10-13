require "system_test_helper"

class CustomElementsTest < ApplicationSystemTestCase
  test "customized elements" do
    visit custom_attrs_path

    assert_selector ".custom-class-for-form"
    assert_selector ".custom-class--fieldset"
    assert_selector ".custom-class--label"
    assert_selector ".custom-class--main_wrapper"
    assert_selector ".custom-class--input"
    assert_selector ".custom-class--handle"
    assert_selector ".custom-class--hidden_field", visible: :hidden
    assert_selector ".custom-class--listbox", visible: :hidden
    assert_selector ".custom-class--dialog", visible: :hidden
    assert_selector ".custom-class--dialog_wrapper", visible: :hidden
    assert_selector ".custom-class--dialog_label", visible: :hidden
    assert_selector ".custom-class--dialog_input", visible: :hidden
    assert_selector ".custom-class--dialog_listbox", visible: :hidden

    assert_selector ".hw-combobox", count: 2
    assert_selector ".hw-combobox__label", count: 2
    assert_selector ".hw-combobox__main__wrapper", count: 2
    assert_selector ".hw-combobox__input", count: 2
    assert_selector ".hw-combobox__handle", count: 2
    assert_selector ".hw-combobox__listbox", visible: :hidden, count: 2
    assert_selector ".hw-combobox__option", visible: :hidden
    assert_selector ".hw-combobox__dialog", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__wrapper", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__label", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__input", visible: :hidden, count: 2
    assert_selector ".hw-combobox__dialog__listbox", visible: :hidden, count: 2

    assert_selector "[data-custom-data-for-form]"
    assert_selector "[data-customized-fieldset]"
    assert_selector "[data-customized-label]"
    assert_selector "[data-customized-main-wrapper]"
    assert_selector "[data-customized-input]"
    assert_selector "[data-customized-handle]"
    assert_selector "[data-customized-hidden-field]", visible: :hidden
    assert_selector "[data-customized-listbox]", visible: :hidden
    assert_selector "[data-customized-dialog]", visible: :hidden
    assert_selector "[data-customized-dialog-wrapper]", visible: :hidden
    assert_selector "[data-customized-dialog-label]", visible: :hidden
    assert_selector "[data-customized-dialog-input]", visible: :hidden
    assert_selector "[data-customized-dialog-listbox]", visible: :hidden
  end
end
