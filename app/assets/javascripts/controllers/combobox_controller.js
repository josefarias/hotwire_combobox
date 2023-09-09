import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "combobox", "listbox", "valueField" ]
  static values = { expanded: Boolean, filterableAttribute: String, autocompletableAttribute: String }

  open() {
    this.expandedValue = true
  }

  close() {
    this.expandedValue = false
  }

  filter(event) {
    const query = this.comboboxTarget.value.trim()

    this.allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

    if (event.inputType === "deleteContentBackward") {
      this.deselect(this.selectedOptionElement)
    } else {
      this.select(this.visibleOptionElements[0])
    }
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

  select(target) {
    this.allOptionElements.forEach(target => this.deselect(target))

    if (target) {
      if (this.hasSelectedClass) target.classList.add(this.selectedClass)

      target.setAttribute("aria-selected", true)
      this.valueFieldTarget.value = target.dataset.value

      this.autocompleteWith(target)
    }
  }

  deselect(target) {
    if (target) {
      if (this.hasSelectedClass) target.classList.remove(this.selectedClass)

      target.setAttribute("aria-selected", false)
      this.valueFieldTarget.value = null
    }
  }

  autocompleteWith(target) {
    const typedValue = this.comboboxTarget.value
    const autocompletedValue = target.dataset.autocompletableAs

    this.comboboxTarget.value = autocompletedValue
    this.comboboxTarget.setSelectionRange(typedValue.length, autocompletedValue.length)
  }

  get allOptionElements() {
    return this.listboxTarget.querySelectorAll(`[${this.filterableAttributeValue}]`)
  }

  get visibleOptionElements() {
    return [ ...this.allOptionElements ].filter(visible)
  }

  get selectedOptionElement() {
    return this.listboxTarget.querySelector("[aria-selected=true]")
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

function visible(target) {
  return !(target.hidden || target.closest("[hidden]"))
}
