require "test_helper"

class HotwireCombobox::ComponentTest < ApplicationViewTestCase
  setup do
    @view = ActionView::Base.new(ActionController::Base.view_paths, {}, ActionController::Base.new)
  end

  test "hidden_field_attrs returns value from form object if available" do
    existent_field_on_model = "Peter"
    field_name = :name
    component = HotwireCombobox::Component.new(
      @view, field_name,
      form: mock_form(form_object: OpenStruct.new("#{field_name}": existent_field_on_model)),
    )

    assert_equal component.hidden_field_attrs, { id: "#{field_name}_id-hw-hidden-field",
                                                 name: :name,
                                                 data: { hw_combobox_target: "hiddenField" },
                                                 value: existent_field_on_model }
  end

  test "hidden_field_attrs returns component value if not available in form object" do
    field_name = "options[name]"
    specified_value = "Peter"
    component = HotwireCombobox::Component.new(
      @view, field_name,
      form: mock_form,
      value: specified_value
    )

    assert_equal component.hidden_field_attrs, { id: "#{field_name}_id-hw-hidden-field",
                                                 name: field_name,
                                                 data: { hw_combobox_target: "hiddenField" },
                                                 value: specified_value }

  end

  test "hidden_field_attrs returns nil for value if neither form object nor component value is available" do
    field_name = "options[name]"
    component = HotwireCombobox::Component.new(
      @view, field_name,
      form: mock_form,
    )

    assert_equal component.hidden_field_attrs, { id: "#{field_name}_id-hw-hidden-field",
                                                 name: field_name,
                                                 data: { hw_combobox_target: "hiddenField" },
                                                 value: nil }

  end
end