module HotwireCombobox::Component::Markup::Fieldset
  def fieldset_attrs
    customize :fieldset, base: {
      class: [ "hw-combobox", { "hw-combobox--multiple": multiselect? } ], data: fieldset_data }
  end

  private
    def fieldset_data
      data.merge \
        async_id: canonical_id,
        controller: view.token_list("hw-combobox", data[:controller]),
        hw_combobox_expanded_value: open,
        hw_combobox_name_when_new_value: name_when_new,
        hw_combobox_original_name_value: hidden_field_name,
        hw_combobox_autocomplete_value: autocomplete,
        hw_combobox_small_viewport_max_width_value: mobile_at,
        hw_combobox_async_src_value: async_src,
        hw_combobox_prefilled_display_value: prefilled_display,
        hw_combobox_selection_chip_src_value: multiselect_chip_src,
        hw_combobox_filterable_attribute_value: "data-filterable-as",
        hw_combobox_autocompletable_attribute_value: "data-autocompletable-as",
        hw_combobox_selected_class: "hw-combobox__option--selected",
        hw_combobox_invalid_class: "hw-combobox__input--invalid"
    end

    def prefilled_display
      return if multiselect? || !hidden_field_value

      if async_src && associated_object
        associated_object.to_combobox_display
      elsif async_src && form_object&.respond_to?(name)
        form_object.public_send name
      else
        options.find_by_value(hidden_field_value)&.autocompletable_as || hidden_field_value
      end
    end
end
