module ApplicationHelper
  def html_combobox_options(options)
    options.map do |option|
      OpenStruct.new(
        content: render("comboboxes/state", state: option.content),
        filterable_as: option.filterable_as)
    end
  end
end
