module ApplicationHelper
  def html_combobox_options(options)
    options.map do |option|
      HotwireCombobox::Option.new \
        id: option.id,
        content: render("comboboxes/state", state: option.content),
        filterable_as: option.filterable_as,
        autocompletable_as: option.autocompletable_as
    end
  end
end
