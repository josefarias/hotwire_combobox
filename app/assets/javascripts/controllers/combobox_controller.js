import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "selected" ]
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

    this.open()

    this.allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

    if (event.inputType === "deleteContentBackward") {
      this.deselect(this.selectedOptionElement)
    } else {
      this.select(this.visibleOptionElements[0])
    }
  }

  navigate(event) {
    this.keyHandlers[event.key]?.call(this, event)
  }

  // private

  keyHandlers = {
    ArrowUp(event) {
      this.selectIndex(this.selectedOptionIndex - 1)
      cancel(event)
    },
    ArrowDown(event) {
      this.selectIndex(this.selectedOptionIndex + 1)
      cancel(event)
    },
    Home(event) {
      this.selectIndex(0)
      cancel(event)
    },
    End(event) {
      this.selectIndex(this.visibleOptionElements.length - 1)
      cancel(event)
    },
    Enter(event) {
      this.commitSelection()
      cancel(event)
    }
  }

  commitSelection() {
    this.select(this.selectedOptionElement, { force: true })
    this.close()
  }

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

  select(option, { force = false } = {}) {
    this.allOptionElements.forEach(option => this.deselect(option))

    if (option) {
      if (this.hasSelectedClass) option.classList.add(this.selectedClass)
      this.maybeAutocompleteWith(option, { force })
      this.executeSelect(option, { selected: true })
    }
  }

  selectIndex(index) {
    const option = wrapAroundAccess(this.visibleOptionElements, index)
    this.select(option, { force: true })
  }

  deselect(option) {
    if (option) {
      if (this.hasSelectedClass) option.classList.remove(this.selectedClass)
      this.executeSelect(option, { selected: false })
    }
  }

  executeSelect(option, { selected }) {
    if (selected) {
      option.setAttribute("aria-selected", true)
      this.valueFieldTarget.value = option.dataset.value
    } else {
      option.setAttribute("aria-selected", false)
      this.valueFieldTarget.value = null
    }
  }

  maybeAutocompleteWith(option, { force }) {
    const typedValue = this.comboboxTarget.value
    const autocompletedValue = option.dataset.autocompletableAs

    if (force) {
      this.comboboxTarget.value = autocompletedValue
      this.comboboxTarget.setSelectionRange(autocompletedValue.length, autocompletedValue.length)
    } else if (autocompletedValue.toLowerCase().startsWith(typedValue.toLowerCase())) {
      this.comboboxTarget.value = autocompletedValue
      this.comboboxTarget.setSelectionRange(typedValue.length, autocompletedValue.length)
    }
  }

  get allOptionElements() {
    return this.listboxTarget.querySelectorAll(`[${this.filterableAttributeValue}]`)
  }

  get visibleOptionElements() {
    return [ ...this.allOptionElements ].filter(visible)
  }

  get selectedOptionElement() {
    return this.listboxTarget.querySelector("[role=option][aria-selected=true]")
  }

  get selectedOptionIndex() {
    return [ ...this.visibleOptionElements ].indexOf(this.selectedOptionElement)
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

function wrapAroundAccess(array, index) {
  const first = 0
  const last = array.length - 1

  if (index < first) return array[last]
  if (index > last) return array[first]
  return array[index]
}

function cancel(event) {
  event.stopPropagation()
  event.preventDefault()
}
