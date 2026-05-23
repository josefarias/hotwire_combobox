import { Controller } from "@hotwired/stimulus"

// Mirrors the intended app-side integration: declare an `hw-combobox` outlet and
// restore each combobox from a snapshot the moment it connects. Snapshots are
// embedded per-combobox as `data-restoration-snapshot` JSON on the fieldset.
export default class extends Controller {
  static outlets = [ "hw-combobox" ]
  static targets = [ "preselectionCount", "selectionCount", "restorationCount" ]

  initialize() {
    this.preselectionCount = 0
    this.selectionCount = 0
    this.restorationCount = 0
  }

  connect() {
    this.preselectionCountTarget.innerText = "preselections: 0."
    this.selectionCountTarget.innerText = "selections: 0."
    this.restorationCountTarget.innerText = "restorations: 0."
  }

  hwComboboxOutletConnected(outlet, element) {
    // Defer one microtask so any `hw-combobox:restoration` listeners wired via
    // data-action on the just-connected combobox are bound before the event fires.
    Promise.resolve().then(() => this.#restore(outlet, element))
  }

  restoreAll() {
    this.hwComboboxOutlets.forEach((outlet, index) => {
      this.#restore(outlet, this.hwComboboxOutletElements[index])
    })
  }

  countPreselection() {
    this.preselectionCount++
    this.preselectionCountTarget.innerText = `preselections: ${this.preselectionCount}.`
  }

  countSelection() {
    this.selectionCount++
    this.selectionCountTarget.innerText = `selections: ${this.selectionCount}.`
  }

  countRestoration() {
    this.restorationCount++
    this.restorationCountTarget.innerText = `restorations: ${this.restorationCount}.`
  }

  #restore(outlet, element) {
    const snapshot = element.dataset.restorationSnapshot
    if (snapshot) outlet.restore(JSON.parse(snapshot))
  }
}
