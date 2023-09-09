module Combobox
  module Helper
    def combobox_tag(name, value = nil, form: nil, options: [], data: {}, input: {}, **attrs)
      value_field_attrs = {}.tap do |h|
        h[:id] = default_combobox_value_field_id attrs, form, name
        h[:name] = default_combobox_value_field_name form, name
        h[:data] = default_combobox_value_field_data
      end

      attrs[:type] ||= :text
      attrs[:role] = :combobox
      attrs[:id] = combobox_id(value_field_attrs[:id])
      attrs[:data] = default_combobox_data input.fetch(:data, {})
      attrs[:aria] = default_combobox_aria value_field_attrs, input.fetch(:aria, {})

      render "combobox/combobox", options: options,
        attrs: attrs, value_field_attrs: value_field_attrs,
        listbox_id: combobox_listbox_id(value_field_attrs[:id]),
        parent_data: default_combobox_parent_data(attrs, data)
    end

    def value_for_listbox_option(option)
      option.try(:value) || option.id
    end

    private
      def default_combobox_value_field_id(attrs, form, name)
        attrs.delete(:id) || form&.field_id(name)
      end

      def default_combobox_value_field_name(form, name)
        form&.field_name(name) || name
      end

      def default_combobox_value_field_data
        { "combobox-target": "valueField" }
      end

      def default_combobox_data(data)
        data.reverse_merge! \
          "action": "focus->combobox#open blur->combobox#close input->combobox#filter",
          "combobox-target": "combobox"
      end

      def default_combobox_aria(attrs, aria)
        aria.reverse_merge! \
          "controls": combobox_listbox_id(attrs[:id]),
          "owns": combobox_listbox_id(attrs[:id]),
          "haspopup": "listbox",
          "autocomplete": "both"
      end

      def default_combobox_parent_data(attrs, data)
        data.reverse_merge! \
          "controller": token_list(:combobox, data.delete(:controller)),
          "combobox-expanded-value": attrs.delete(:open),
          "combobox-filterable-attribute-value": "data-filterable-as",
          "combobox-autocompletable-attribute-value": "data-autocompletable-as"
      end

      def combobox_id(id)
        "#{id}-combobox"
      end

      def combobox_listbox_id(id)
        "#{id}-listbox"
      end
  end
end
