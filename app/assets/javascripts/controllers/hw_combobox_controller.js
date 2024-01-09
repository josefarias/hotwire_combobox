import Combobox from "models/combobox"
import { Concerns } from "helpers"
import { Controller } from "@hotwired/stimulus"

const concerns = [
  Controller,
  Combobox.Actors,
  Combobox.Autocomplete,
  Combobox.Dialog,
  Combobox.Filtering,
  Combobox.Navigation,
  Combobox.Options,
  Combobox.Selection,
  Combobox.Toggle,
  Combobox.Validity
]

export default class HwComboboxController extends Concerns(...concerns) {
  static classes = [
    "invalid",
    "selected"
  ]

  static targets = [
    "combobox",
    "dialog",
    "dialogCombobox",
    "dialogFocusTrap",
    "dialogListbox",
    "hiddenField",
    "listbox"
  ]

  static values = {
    autocompletableAttribute: String,
    autocomplete: String,
    expanded: Boolean,
    filterableAttribute: String,
    nameWhenNew: String,
    originalName: String,
    smallViewportMaxWidth: String
  }

  initialize() {
    this._initializeActors()
  }

  connect() {
    this._initializeSelection()
    this._initializeListAutocomplete()
  }

  expandedValueChanged() {
    if (this.expandedValue) {
      this._expand()
    } else {
      this._collapse()
    }
  }
}
