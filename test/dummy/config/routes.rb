Rails.application.routes.draw do
  mount Combobox::Engine => "/combobox"
  get "open_combobox", to: "comboboxes#open"
  get "html_combobox", to: "comboboxes#html"
  root to: "comboboxes#new"
end
