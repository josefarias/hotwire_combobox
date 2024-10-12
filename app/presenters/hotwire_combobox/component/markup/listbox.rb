module HotwireCombobox::Component::Markup::Listbox
  def listbox_attrs
    customize :listbox, base: {
      id: listbox_id, role: :listbox, hidden: "",
      class: "hw-combobox__listbox",
      data: { hw_combobox_target: "listbox" },
      aria: { multiselectable: multiselect? } }
  end

  private
    def listbox_id
      "#{canonical_id}-hw-listbox"
    end
end
