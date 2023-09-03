Rails.application.routes.draw do
  mount Combobox::Engine => "/combobox"
  get "open_combobox", to: "comboboxes#open"
  root to: "comboboxes#new"
end
