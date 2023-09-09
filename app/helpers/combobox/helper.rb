module Combobox
  module Helper
    def combobox_tag(name, value = nil, form: nil, options: [], data: {}, input: {}, **attrs)
      attrs[:type] ||= :text
      attrs[:role] = :combobox
      attrs[:id] = default_combobox_id attrs, form, name
      attrs[:name] = default_combobox_name form, name
      attrs[:data] = default_combobox_data attrs, input.fetch(:data, {})
      attrs[:aria] = default_combobox_aria attrs, input.fetch(:aria, {})

      render "combobox/combobox", options: options,
        attrs: attrs, listbox_id: combobox_listbox_id(attrs[:id]),
        parent_data: default_combobox_parent_data(attrs, data)
    end

    private
      def default_combobox_id(attrs, form, name)
        attrs[:id] ||= form&.field_id(name)
      end

      def default_combobox_name(form, name)
        form&.field_name(name) || name
      end

      def default_combobox_data(attrs, data)
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
          "combobox-filterable-attribute-value": "data-filterable-as"
      end

      def combobox_listbox_id(id)
        "#{id}-listbox"
      end
  end
end
