Rails.application.routes.draw do
  get "async", to: "comboboxes#async"
  get "async_html", to: "comboboxes#async_html"
  get "async_preload", to: "comboboxes#async_preload"
  get "conflicting_order", to: "comboboxes#conflicting_order"
  get "custom_attrs", to: "comboboxes#custom_attrs"
  get "custom_events", to: "comboboxes#custom_events"
  get "dialog", to: "comboboxes#dialog"
  get "enum", to: "comboboxes#enum"
  get "external_clear", to: "comboboxes#external_clear"
  get "form_object", to: "comboboxes#form_object"
  get "formbuilder", to: "comboboxes#formbuilder"
  get "freetext_async", to: "comboboxes#freetext_async"
  get "grouped_options", to: "comboboxes#grouped_options"
  get "html_options", to: "comboboxes#html_options"
  get "include_blank", to: "comboboxes#include_blank"
  get "inline_autocomplete", to: "comboboxes#inline_autocomplete"
  get "list_autocomplete", to: "comboboxes#list_autocomplete"
  get "morph", to: "comboboxes#morph"
  get "multiselect", to: "comboboxes#multiselect"
  get "multiselect_async_html", to: "comboboxes#multiselect_async_html"
  get "multiselect_custom_events", to: "comboboxes#multiselect_custom_events"
  get "multiselect_dismissing", to: "comboboxes#multiselect_dismissing"
  get "multiselect_new_values", to: "comboboxes#multiselect_new_values"
  get "multiselect_prefilled_form", to: "comboboxes#multiselect_prefilled_form"
  get "new_options", to: "comboboxes#new_options"
  get "open", to: "comboboxes#open"
  get "padded", to: "comboboxes#padded"
  get "plain", to: "comboboxes#plain"
  get "prefilled", to: "comboboxes#prefilled"
  get "prefilled_async", to: "comboboxes#prefilled_async"
  get "prefilled_form", to: "comboboxes#prefilled_form"
  get "prefilled_free_text", to: "comboboxes#prefilled_free_text"
  get "prefilled_html", to: "comboboxes#prefilled_html"
  get "render_in", to: "comboboxes#render_in"
  get "render_in_locals", to: "comboboxes#render_in_locals"
  get "required", to: "comboboxes#required"

  resources :movies, only: %i[ index update ]
  get "movies_html", to: "movies#index_html"
  get "movies_with_blank", to: "movies#index_with_blank"
  get "movies_with_blank_html", to: "movies#index_with_blank_html"

  resources :movie_ratings, only: :index

  get "greeting", to: "greetings#new"

  post "new_options_form", to: "new_options_forms#create"

  resources :states, only: :index
  resources :state_chips, only: :create, param: :combobox_value
  post "html_state_chips", to: "state_chips#create_html"
  post "dismissing_state_chips", to: "state_chips#create_dismissing"
  post "possibly_new_state_chips", to: "state_chips#create_possibly_new"

  resources :users, only: :update do
    resources :visits, only: :create
  end

  root to: "comboboxes#plain"
end
