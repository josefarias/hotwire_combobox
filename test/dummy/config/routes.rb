Rails.application.routes.draw do
  get "plain", to: "comboboxes#plain"
  get "open", to: "comboboxes#open"
  get "html_options", to: "comboboxes#html_options"
  get "prefilled", to: "comboboxes#prefilled"
  get "required", to: "comboboxes#required"
  get "formbuilder", to: "comboboxes#formbuilder"
  get "new_options", to: "comboboxes#new_options"
  get "inline_autocomplete", to: "comboboxes#inline_autocomplete"
  get "list_autocomplete", to: "comboboxes#list_autocomplete"
  get "async", to: "comboboxes#async"
  get "prefilled_async", to: "comboboxes#prefilled_async"
  get "prefilled_form", to: "comboboxes#prefilled_form"
  get "async_html", to: "comboboxes#async_html"
  get "render_in", to: "comboboxes#render_in"

  get "movies", to: "movies#index"
  get "movies_html", to: "movies#index_html"

  get "greeting", to: "greetings#new"

  post "new_options_form", to: "new_options_forms#create"

  resources :states, only: :index
  resources :users, only: :update

  root to: "comboboxes#plain"
end
