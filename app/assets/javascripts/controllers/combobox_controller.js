import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "combobox", "listbox" ]
  static values = { expanded: Boolean }

  connect() {
    this.comboboxTarget.setAttribute("role", "combobox")
    this.comboboxTarget.setAttribute("aria-owns", this.listboxTarget.id)
    this.comboboxTarget.setAttribute("aria-controls", this.listboxTarget.id)
    this.comboboxTarget.setAttribute("aria-haspopup", "listbox")
  }

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
