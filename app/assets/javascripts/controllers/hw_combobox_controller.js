import Combobox from "hw_combobox/models/combobox"
import { Concerns } from "hw_combobox/helpers"
import { Controller } from "@hotwired/stimulus"

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
  Combobox.Restoration,
  Combobox.Selection,
  Combobox.Toggle,
  Combobox.Validity
]

export default class HwComboboxController extends Concerns(...concerns) {
  static classes = [ "invalid", "selected" ]
  static targets = [
    "announcer",
    "combobox",
    "chipDismisser",
    "dialog", "dialogCombobox", "dialogFocusTrap", "dialogListbox",
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
    debounceInterval: Number,
    expanded: Boolean,
    filterableAttribute: String,
    nameWhenNew: String,
    originalName: String,
    prefilledChips: Array,
    prefilledDisplay: String,
    selectionChipSrc: String,
    smallViewportMaxWidth: String
  }

  initialize() {
    this._initializeActors()
    this._initializeFiltering()
  }

  connect() {
    this.idempotentConnect()
  }

  idempotentConnect() {
    this._connectSelection()
    this._connectMultiselect()
    this._connectRequired()
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

  endOfOptionsStreamTargetConnected(element) {
    const inputType = this._claimUnhandledInputType(element)

    this._resetMultiselectionMarks()

    if (inputType) {
      this._selectOnQueryUnlessAlreadySelected(inputType)
    } else {
      this._preselectSingle()
    }
  }

  _claimUnhandledInputType(element) {
    const inputType = element.dataset.inputType
    delete element.dataset.inputType

    return inputType
  }

  _selectOnQueryUnlessAlreadySelected(inputType) {
    if (inputType === "hw:lockInSelection" || inputType === "hw:multiselectSync") return

    this._selectOnQuery(inputType)
  }

  // Use +_printStack+ for debugging purposes
  _printStack() {
    const err = new Error()
    console.log(err.stack || err.stacktrace)
  }
}
