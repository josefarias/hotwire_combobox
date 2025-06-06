module HotwireCombobox::Component::Markup::Input
  def input_attrs
    customize :input, base: {
      id: input_id, role: :combobox, type: input_type,
      class: "hw-combobox__input", autocomplete: :off,
      data: input_data, aria: input_aria
    }.merge(combobox_attrs.except(:data, :aria))
  end

  private
    def input_id
      canonical_id
    end

    def input_type
      combobox_attrs[:type].to_s.presence_in(%w[ text search ]) || "text"
    end

    def input_data
      data = combobox_attrs.fetch(:data, {}).dup
      action = %w[
        click->hw-combobox#toggle
        keydown->hw-combobox#prepareToFilter
        input->hw-combobox#filterAndSelect
        keydown->hw-combobox#navigate
        click@window->hw-combobox#closeOnClickOutside
        focusin@window->hw-combobox#closeOnFocusOutside
        turbo:before-stream-render@document->hw-combobox#rerouteListboxStreamToDialog
        turbo:before-cache@document->hw-combobox#hideChipsForCache
        turbo:morph-element->hw-combobox#idempotentConnect
      ].append(data.delete(:action)).compact.join(" ")

      data.merge action: action, hw_combobox_target: "combobox", async_id: canonical_id
    end

    def input_aria
      combobox_attrs.fetch(:aria, {}).merge \
        controls: listbox_id,
        owns: listbox_id,
        haspopup: "listbox",
        autocomplete: autocomplete,
        activedescendant: ""
    end
end
