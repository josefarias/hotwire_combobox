module HotwireCombobox::Component::Customizable
  CUSTOMIZABLE_ELEMENTS = %i[
    dialog dialog_input dialog_label dialog_listbox dialog_wrapper
    fieldset
    handle
    hidden_field
    input
    label
    listbox
    main_wrapper
  ].freeze

  PROTECTED_ATTRS = %i[ for hidden id name open role value ].freeze

  CUSTOMIZABLE_ELEMENTS.each do |element|
    define_method "customize_#{element}" do |**attrs|
      store_customizations element, **attrs
    end
  end

  private
    def custom_attrs
      @custom_attrs ||= Hash.new { |h, k| h[k] = {} }
    end

    def store_customizations(element, **attrs)
      element = element.to_sym.presence_in(CUSTOMIZABLE_ELEMENTS)
      sanitized_attrs = attrs.deep_symbolize_keys.except(*PROTECTED_ATTRS)

      custom_attrs.store element, sanitized_attrs
    end

    def customize(element, base: {})
      custom = custom_attrs[element]

      coalesce = ->(key, value) do
        if custom.has_key?(key) && (value.is_a?(String) || value.is_a?(Array))
          view.token_list(value, custom.delete(key))
        else
          value
        end
      end

      default = base.map { |k, v| [ k, coalesce.(k, v) ] }.to_h

      custom.deep_merge default
    end
end
