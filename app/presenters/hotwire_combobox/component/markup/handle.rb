module HotwireCombobox::Component::Markup::Handle
  def handle_attrs
    customize :handle, base: {
      class: "hw-combobox__handle",
      data: { action: "click->hw-combobox#clearOrToggleOnHandleClick", hw_combobox_target: "handle" } }
  end
end
