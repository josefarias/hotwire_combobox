Rails.application.routes.draw do
  mount HotwireCombobox::Engine => "/hotwire_combobox"

  get "plain_combobox", to: "comboboxes#plain"
  get "open_combobox", to: "comboboxes#open"
  get "html_combobox", to: "comboboxes#html"
  get "prefilled_combobox", to: "comboboxes#prefilled"
  get "required_combobox", to: "comboboxes#required"

  root to: "comboboxes#plain"
end
