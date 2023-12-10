module HotwireCombobox
  module Helper
    def hw_combobox_tag(name, value = nil, form: nil, options: [], data: {}, input: {}, **attrs)
      value_field_attrs = {}.tap do |h|
        h[:id] = default_hw_combobox_value_field_id attrs, form, name
        h[:name] = default_hw_combobox_value_field_name form, name
        h[:data] = default_hw_combobox_value_field_data
        h[:value] = form&.object&.public_send(name) || value
      end

      attrs[:type] ||= :text
      attrs[:role] = :combobox
      attrs[:id] = hw_combobox_id value_field_attrs[:id]
      attrs[:data] = default_hw_combobox_data input.fetch(:data, {})
      attrs[:aria] = default_hw_combobox_aria value_field_attrs, input.fetch(:aria, {})

      render "hotwire_combobox/combobox", options: options,
        attrs: attrs, value_field_attrs: value_field_attrs,
        listbox_id: hw_combobox_listbox_id(value_field_attrs[:id]),
        parent_data: default_hw_combobox_parent_data(attrs, data)
    end

    def value_for_hw_listbox_option(option)
      option.try(:value) || option.id
    end

    private
      def default_hw_combobox_value_field_id(attrs, form, name)
        attrs.delete(:id) || form&.field_id(name)
      end

      def default_hw_combobox_value_field_name(form, name)
        form&.field_name(name) || name
      end

      def default_hw_combobox_value_field_data
        { "hw-combobox-target": "valueField" }
      end

      def default_hw_combobox_data(data)
        data.reverse_merge! \
          "action": "
            focus->hw-combobox#open
            input->hw-combobox#filter
            keydown->hw-combobox#navigate
            click@window->hw-combobox#closeOnClickOutside
            focusin@window->hw-combobox#closeOnFocusOutside".squish,
          "hw-combobox-target": "combobox"
      end

      def default_hw_combobox_aria(attrs, aria)
        aria.reverse_merge! \
          "controls": hw_combobox_listbox_id(attrs[:id]),
          "owns": hw_combobox_listbox_id(attrs[:id]),
          "haspopup": "listbox",
          "autocomplete": "both"
      end

      def default_hw_combobox_parent_data(attrs, data)
        data.reverse_merge! \
          "controller": token_list("hw-combobox", data.delete(:controller)),
          "hw-combobox-expanded-value": attrs.delete(:open),
          "hw-combobox-filterable-attribute-value": "data-filterable-as",
          "hw-combobox-autocompletable-attribute-value": "data-autocompletable-as"
      end

      def hw_combobox_id(id)
        "#{id}-hw-combobox"
      end

      def hw_combobox_listbox_id(id)
        "#{id}-hw-listbox"
      end
  end
end
