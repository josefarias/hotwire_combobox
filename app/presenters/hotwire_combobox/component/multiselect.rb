module HotwireCombobox::Component::Multiselect
  private
    def multiselect?
      multiselect_chip_src.present?
    end
end
