Rails.application.routes.draw do
  mount Combobox::Engine => "/combobox"
  root to: "comboboxes#new"
end
