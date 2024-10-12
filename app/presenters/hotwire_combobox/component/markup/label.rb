module HotwireCombobox::Component::Markup::Label
  def label_attrs
    customize :label, base: { class: "hw-combobox__label", for: input_id, hidden: label.blank? }
  end
end
