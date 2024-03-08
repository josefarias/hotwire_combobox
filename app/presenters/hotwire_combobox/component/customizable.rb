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
      element = element.to_sym.presence_in(CUSTOMIZABLE_ELEMENTS) ||
        raise(ArgumentError, <<~MSG)
          [ACTION NEEDED] – Message from HotwireCombobox:

          You tried to customize an element called `#{element}`, but
          HotwireCombobox does not recognize that element.

          Please choose one of the valid elements: #{CUSTOMIZABLE_ELEMENTS.join(", ")}.
        MSG

      custom_attrs[element] = attrs.deep_symbolize_keys.delete_if do |key, _|
        PROTECTED_ATTRS.include? key
      end
    end

    def apply_customizations_to(element, base: {})
      custom = custom_attrs[element]
      default = base.deep_symbolize_keys.map do |key, value|
        if value.is_a?(String) || value.is_a?(Symbol)
          [ key, view.token_list(value.to_s, custom.delete(key)) ]
        else
          [ key, value ]
        end
      end.to_h

      custom.deep_merge default
    end
end
