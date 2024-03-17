import Combobox from "hw_combobox/models/combobox"
import { Concerns, sleep } from "hw_combobox/helpers"
import { Controller } from "@hotwired/stimulus"

window.HOTWIRE_COMBOBOX_STREAM_DELAY = 0 // ms, for testing purposes

const concerns = [
  Controller,
  Combobox.Actors,
  Combobox.Announcements,
  Combobox.AsyncLoading,
  Combobox.Autocomplete,
  Combobox.Dialog,
  Combobox.Events,
  Combobox.Filtering,
  Combobox.FormField,
  Combobox.Multiselect,
  Combobox.Navigation,
  Combobox.NewOptions,
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
    "announcer",
    "combobox",
    "chipDismisser",
    "closer",
    "dialog",
    "dialogCombobox",
    "dialogFocusTrap",
    "dialogListbox",
    "endOfOptionsStream",
    "handle",
    "hiddenField",
    "listbox",
    "mainWrapper"
  ]

  static values = {
    asyncSrc: String,
    autocompletableAttribute: String,
    autocomplete: String,
    expanded: Boolean,
    filterableAttribute: String,
    nameWhenNew: String,
    originalName: String,
    prefilledDisplay: String,
    selectionChipSrc: String,
    smallViewportMaxWidth: String
  }

  initialize() {
    this._initializeActors()
    this._initializeFiltering()
  }

  connect() {
    this._connectSelection()
    this._connectListAutocomplete()
    this._connectDialog()
  }

  disconnect() {
    this._disconnectDialog()
  }

  expandedValueChanged() {
    if (this.expandedValue) {
      this._expand()
    } else {
      this._collapse()
    }
  }

  async endOfOptionsStreamTargetConnected(element) {
    const inputType = element.dataset.inputType
    const delay = window.HOTWIRE_COMBOBOX_STREAM_DELAY

    this._resetMultiselectionMarks()

    if (inputType && inputType !== "hw:lockInSelection") {
      if (delay) await sleep(delay)
      this._selectOnQuery(inputType)
    } else {
      this._preselect()
    }
  }

  closerTargetConnected() {
    this._closeAndBlur()
  }

  // Use +_printStack+ for debugging purposes
  _printStack() {
    const err = new Error()
    console.log(err.stack || err.stacktrace)
  }
}
