import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "combobox", "listbox" ]
  static values = { expanded: Boolean }

  toggle() {
    this.expandedValue = !this.expandedValue
  }

  // private

  expandedValueChanged() {
    if (this.expandedValue) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  expand() {
    this.listboxTarget.hidden = false
    this.comboboxTarget.setAttribute("aria-expanded", true)
  }

  collapse() {
    this.listboxTarget.hidden = true
    this.comboboxTarget.setAttribute("aria-expanded", false)
  }
}
