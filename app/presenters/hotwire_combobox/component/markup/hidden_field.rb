module HotwireCombobox::Component::Markup::HiddenField
  def hidden_field_attrs
    customize :hidden_field, base: {
      id: hidden_field_id, name: hidden_field_name, value: hidden_field_value,
      data: { hw_combobox_target: "hiddenField" } }
  end

  private
    def hidden_field_id
      "#{canonical_id}-hw-hidden-field"
    end

    def hidden_field_name
      form&.field_name(name) || name
    end

    def hidden_field_value
      return value if value

      if form_object&.try(:defined_enums)&.try(:[], name)
        form_object.public_send "#{name}_before_type_cast"
      else
        form_object&.try(name).then do |value|
          value.respond_to?(:map) ? value.join(",") : value
        end
      end
    end
end
