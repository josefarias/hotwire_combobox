Rails.application.routes.draw do
  mount Combobox::Engine => "/combobox"

  get "plain_combobox", to: "comboboxes#plain"
  get "open_combobox", to: "comboboxes#open"
  get "html_combobox", to: "comboboxes#html"

  root to: "comboboxes#plain"
end
