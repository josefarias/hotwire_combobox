module HotwireCombobox::Component::Announced
  def announcer_attrs
    { class: "hw-combobox__announcer", data: { hw_combobox_target: "announcer" }, aria: { live: :polite, atomic: true } }
  end
end
