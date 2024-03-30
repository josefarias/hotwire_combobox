class HotwireCombobox::Listbox::Item::Collection < Array
  def find(&block)
    if grouped?
      flat_map { |item| item.options }.find(&block)
    else
      super(&block)
    end
  end

  private
    def grouped?
      first.is_a? HotwireCombobox::Listbox::Group
    end
end
