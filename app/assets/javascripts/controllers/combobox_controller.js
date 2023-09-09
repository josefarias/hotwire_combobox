import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "combobox", "listbox" ]
  static values = { expanded: Boolean, filterableAttribute: String }

  open() {
    this.expandedValue = true
  }

  close() {
    this.expandedValue = false
  }

  filter() {
    const query = this.comboboxTarget.value.trim()
    this.optionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))
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

  get optionElements() {
    return this.listboxTarget.querySelectorAll(`[${this.filterableAttributeValue}]`)
  }
}

function applyFilter(query, { matching }) {
  return (target) => {
    if (query) {
      const value = target.getAttribute(matching) || ""
      const match = value.toLowerCase().includes(query.toLowerCase())

      target.hidden = !match
    } else {
      target.hidden = false
    }
  }
}
