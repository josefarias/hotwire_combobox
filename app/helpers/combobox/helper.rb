module Combobox
  module Helper
    def combobox_tag(name, value = nil, form: nil, options: [], data: {}, input: {}, **attrs)
      attrs[:type] ||= :text
      attrs[:id] = default_combobox_id attrs, form, name
      attrs[:name] = default_combobox_name form, name
      attrs[:data] = default_combobox_data attrs, input.fetch(:data, {})

      render "combobox/combobox", options: options,
        attrs: attrs, listbox_id: "#{attrs[:id]}-listbox",
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
          "action": "click->combobox#toggle",
          "combobox-target": "combobox"
      end

      def default_combobox_parent_data(attrs, data)
        data.reverse_merge! \
          "controller": token_list(:combobox, data.delete(:controller)),
          "combobox-expanded-value": attrs.delete(:open)
      end
  end
end
