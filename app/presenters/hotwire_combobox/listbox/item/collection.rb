class HotwireCombobox::Listbox::Item::Collection < Array
  def find_by_value(value)
    if grouped?
      flat_map { |item| item.options }.find { |option| option.value == value }
    else
      find { |option| option.value == value }
    end
  end

  private
    def grouped?
      first.is_a? HotwireCombobox::Listbox::Group
    end
end
