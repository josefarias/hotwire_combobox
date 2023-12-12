module ApplicationHelper
  def html_combobox_options(options)
    options.map do |option|
      {
        id: option.id,
        display: option.display,
        content: render("comboboxes/state", state: option.display)
      }
    end.then { |options| combobox_options options }
  end
end
