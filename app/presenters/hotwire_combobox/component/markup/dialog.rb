module HotwireCombobox::Component::Markup::Dialog
  def dialog_wrapper_attrs
    customize :dialog_wrapper, base: { class: "hw-combobox__dialog__wrapper" }
  end

  def dialog_attrs
    customize :dialog, base: {
      class: "hw-combobox__dialog", role: :dialog, data: {
      action: "keydown->hw-combobox#navigate", hw_combobox_target: "dialog" } }
  end

  def dialog_label
    @dialog_label || label
  end

  def dialog_label_attrs
    customize :dialog_label, base: { class: "hw-combobox__dialog__label", for: dialog_input_id }
  end

  def dialog_input_attrs
    customize :dialog_input, base: {
      id: dialog_input_id, role: :combobox, autofocus: "", type: input_type,
      class: "hw-combobox__dialog__input", data: dialog_input_data, aria: dialog_input_aria }
  end

  def dialog_listbox_attrs
    customize :dialog_listbox, base: {
      id: dialog_listbox_id, role: :listbox, class: "hw-combobox__dialog__listbox",
      data: { hw_combobox_target: "dialogListbox" }, aria: { multiselectable: multiselect? } }
  end

  def dialog_focus_trap_attrs
    { tabindex: "-1", data: { hw_combobox_target: "dialogFocusTrap" } }
  end

  private
    def dialog_input_id
      "#{canonical_id}-hw-dialog-combobox"
    end

    def dialog_input_data
      { action: "
          input->hw-combobox#filterAndSelect
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside".squish,
        hw_combobox_target: "dialogCombobox" }
    end

    def dialog_input_aria
      { controls: dialog_listbox_id, owns: dialog_listbox_id, autocomplete: autocomplete, activedescendant: "" }
    end

    def dialog_listbox_id
      "#{canonical_id}-hw-dialog-listbox"
    end
end
