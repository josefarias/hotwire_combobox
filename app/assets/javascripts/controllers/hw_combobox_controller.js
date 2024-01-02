import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "selected", "invalid" ]
  static targets = [ "combobox", "listbox", "hiddenField" ]
  static values = {
    expanded: Boolean,
    nameWhenNew: String,
    autocomplete: String,
    originalName: String,
    filterableAttribute: String,
    autocompletableAttribute: String }

  connect() {
    if (this.hiddenFieldTarget.value) this.#selectOptionByValue(this.hiddenFieldTarget.value)
    if (!this.#autocompletesList) this.listboxTarget.style.display = "none"
  }

  open() {
    this.expandedValue = true
  }

  close() {
    if (!this.#isOpen) return
    this.#commitSelection()
    this.expandedValue = false
  }

  selectOption(event) {
    this.#select(event.currentTarget)
    this.close()
  }

  filter(event) {
    const isDeleting = event.inputType === "deleteContentBackward"
    const query = this.comboboxTarget.value.trim()

    this.open()

    this.#allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

    if (this.#isValidNewOption(query, { ignoreAutocomplete: isDeleting })) {
      this.#selectNew(query)
    } else if (isDeleting) {
      this.#deselect(this.#selectedOptionElement)
    } else {
      this.#select(this.#visibleOptionElements[0])
    }
  }

  navigate(event) {
    if (this.#autocompletesList) {
      this.#keyHandlers[event.key]?.call(this, event)
    }
  }

  closeOnClickOutside({ target }) {
    if (this.element.contains(target)) return

    this.close()
  }

  closeOnFocusOutside({ target }) {
    if (!this.#isOpen) return
    if (this.element.contains(target)) return
    if (target.matches("main")) return

    this.close()
  }

  expandedValueChanged() {
    if (this.expandedValue) {
      this.#expand()
    } else {
      this.#collapse()
    }
  }

  #keyHandlers = {
    ArrowUp: (event) => {
      this.#selectIndex(this.#selectedOptionIndex - 1)
      cancel(event)
    },
    ArrowDown: (event) => {
      this.#selectIndex(this.#selectedOptionIndex + 1)
      cancel(event)
    },
    Home: (event) => {
      this.#selectIndex(0)
      cancel(event)
    },
    End: (event) => {
      this.#selectIndex(this.#visibleOptionElements.length - 1)
      cancel(event)
    },
    Enter: (event) => {
      this.close()
      cancel(event)
    }
  }

  #commitSelection() {
    if (!this.#isValidNewOption(this.comboboxTarget.value, { ignoreAutocomplete: true })) {
      this.#select(this.#selectedOptionElement, { force: true })
    }
  }

  #expand() {
    this.listboxTarget.hidden = false
    this.comboboxTarget.setAttribute("aria-expanded", true)
  }

  #collapse() {
    this.listboxTarget.hidden = true
    this.comboboxTarget.setAttribute("aria-expanded", false)
  }

  #select(option, { force = false } = {}) {
    this.#resetOptions()

    if (option) {
      if (this.hasSelectedClass) option.classList.add(this.selectedClass)
      if (this.hasInvalidClass) this.comboboxTarget.classList.remove(this.invalidClass)

      this.#maybeAutocompleteWith(option, { force })
      this.#executeSelect(option, { selected: true })
    } else {
      if (this.#valueIsInvalid) {
        if (this.hasInvalidClass) this.comboboxTarget.classList.add(this.invalidClass)

        this.comboboxTarget.setAttribute("aria-invalid", true)
        this.comboboxTarget.setAttribute("aria-errormessage", `Please select a valid option for ${this.comboboxTarget.name}`)
      }
    }
  }

  #selectNew(query) {
    this.#resetOptions()
    this.hiddenFieldTarget.value = query
    this.hiddenFieldTarget.name = this.nameWhenNewValue
  }

  #resetOptions() {
    this.#allOptionElements.forEach(option => this.#deselect(option))
    this.hiddenFieldTarget.name = this.originalNameValue
  }

  #selectIndex(index) {
    const option = wrapAroundAccess(this.#visibleOptionElements, index)
    this.#select(option, { force: true })
  }

  #selectOptionByValue(value) {
    this.#allOptions.find(option => option.dataset.value === value)?.click()
  }

  #deselect(option) {
    if (option) {
      if (this.hasSelectedClass) option.classList.remove(this.selectedClass)
      this.#executeSelect(option, { selected: false })
    }
  }

  #executeSelect(option, { selected }) {
    if (selected) {
      option.setAttribute("aria-selected", true)
      this.hiddenFieldTarget.value = option.dataset.value
    } else {
      option.setAttribute("aria-selected", false)
      this.hiddenFieldTarget.value = null
    }
  }

  #maybeAutocompleteWith(option, { force }) {
    if (!this.#autocompletesInline && !force) return

    const typedValue = this.comboboxTarget.value
    const autocompletedValue = option.getAttribute(this.autocompletableAttributeValue)

    if (force) {
      this.comboboxTarget.value = autocompletedValue
      this.comboboxTarget.setSelectionRange(autocompletedValue.length, autocompletedValue.length)
    } else if (startsWith(autocompletedValue, typedValue)) {
      this.comboboxTarget.value = autocompletedValue
      this.comboboxTarget.setSelectionRange(typedValue.length, autocompletedValue.length)
    }
  }

  #isValidNewOption(query, { ignoreAutocomplete = false } = {}) {
    const typedValue = this.comboboxTarget.value
    const autocompletedValue = this.#visibleOptionElements[0]?.getAttribute(this.autocompletableAttributeValue)
    const insufficentAutocomplete = !autocompletedValue || !startsWith(autocompletedValue, typedValue)

    return query.length > 0 && this.#allowNew && (ignoreAutocomplete || insufficentAutocomplete)
  }

  get #allOptions() {
    return Array.from(this.#allOptionElements)
  }

  get #allOptionElements() {
    return this.listboxTarget.querySelectorAll(`[${this.filterableAttributeValue}]`)
  }

  get #visibleOptionElements() {
    return [ ...this.#allOptionElements ].filter(visible)
  }

  get #selectedOptionElement() {
    return this.listboxTarget.querySelector("[role=option][aria-selected=true]")
  }

  get #selectedOptionIndex() {
    return [ ...this.#visibleOptionElements ].indexOf(this.#selectedOptionElement)
  }

  get #isOpen() {
    return this.expandedValue
  }

  get #valueIsInvalid() {
    const isRequiredAndEmpty = this.comboboxTarget.required && !this.hiddenFieldTarget.value
    return isRequiredAndEmpty
  }

  get #allowNew() {
    return !!this.nameWhenNewValue
  }

  get #autocompletesList() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "list"
  }

  get #autocompletesInline() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "inline"
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

function startsWith(string, substring) {
  return string.toLowerCase().startsWith(substring.toLowerCase())
}
