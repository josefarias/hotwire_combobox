Rails.application.routes.draw do
  mount HotwireCombobox::Engine => "/hotwire_combobox"

  get "plain_combobox", to: "comboboxes#plain"
  get "open_combobox", to: "comboboxes#open"
  get "html_combobox", to: "comboboxes#html"
  get "prefilled_combobox", to: "comboboxes#prefilled"
  get "required_combobox", to: "comboboxes#required"
  get "formbuilder_combobox", to: "comboboxes#formbuilder"
  get "new_options_combobox", to: "comboboxes#new_options"
  get "inline_autocomplete_combobox", to: "comboboxes#inline_autocomplete"
  get "list_autocomplete_combobox", to: "comboboxes#list_autocomplete"

  post "new_options_form", to: "new_options_forms#create"

  root to: "comboboxes#plain"
end
