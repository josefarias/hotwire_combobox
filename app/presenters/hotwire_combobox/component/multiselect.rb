module HotwireCombobox::Component::Multiselect
  def chip_template_render_options
    case chip_template
    when nil    then nil
    when String then { partial: chip_template }
    when Hash   then chip_template
    end
  end

  private
    def multiselect?
      multiselect_chip_src.present? || chip_template.present?
    end
end
