module HotwireCombobox::Component::Customizable
  CUSTOMIZABLE_ELEMENTS = %i[
    fieldset
    hidden_field
    input
    handle
    listbox
    dialog
    dialog_wrapper
    dialog_label
    dialog_input
    dialog_listbox
  ].freeze

  PROTECTED_ATTRS = %i[
    id
    name
    value
    open
    role
    hidden
  ].freeze

  CUSTOMIZABLE_ELEMENTS.each do |element|
    define_method "customize_#{element}" do |**attrs|
      customize element, **attrs
    end
  end

  private
    def custom_attrs
      @custom_attrs ||= Hash.new { |h, k| h[k] = {} }
    end

    def customize(element, **attrs)
      element = element.to_sym.presence_in(CUSTOMIZABLE_ELEMENTS)
      sanitized_attrs = attrs.deep_symbolize_keys.except(*PROTECTED_ATTRS)

      custom_attrs.store element, sanitized_attrs
    end

    def apply_customizations_to(element, base: {})
      custom = custom_attrs[element]
      coalesce = ->(k, v) { v.is_a?(String) ? view.token_list(v, custom.delete(k)) : v }
      default = base.map { |k, v| [ k, coalesce.(k, v) ] }.to_h

      custom.deep_merge default
    end
end
