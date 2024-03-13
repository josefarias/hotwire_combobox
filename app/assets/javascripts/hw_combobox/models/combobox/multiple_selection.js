import Combobox from "hw_combobox/models/combobox/base"

Combobox.MultipleSelection = Base => class extends Base {
  deSelectOption(event) {
    const element = event.target
    const value = element.getAttribute("data-value")
    this._commitMultipleSelection({ value }, { selected: false })
    element.parentElement.remove()
    this._markInvalid()
  }

  _connectMultipleSelection() {
    if (this.hasMultipleSelectionsValue) {
      const selectedValues = Object.keys(this.multipleSelectionsValue)
      selectedValues.forEach((selectedValue) => {
        this._renderSelection(selectedValue, this.multipleSelectionsValue[selectedValue])
      })
      this.hiddenFieldTarget.value = JSON.stringify(selectedValues)
    }
  }

  _renderSelection(value, display) {
    const selectionWrapper = document.createElement("div")
    selectionWrapper.id = value
    selectionWrapper.classList.add("hw-combobox__multiple_selection")
    const text = document.createElement("div")
    text.textContent = display
    const closer = document.createElement("div")
    closer.classList.add("hw-combobox__multiple_selection__remove")
    closer.setAttribute("data-action", "click->hw-combobox#deSelectOption")
    closer.setAttribute("data-value", value)
    selectionWrapper.appendChild(text)
    selectionWrapper.appendChild(closer)
    this.innerWrapperTarget.insertBefore(selectionWrapper, this.comboboxTarget)
  }

  _commitMultipleSelection(option, { selected }) {
    const newSelections = { ...this.multipleSelectionsValue }
    if (selected) {
      const value = option.getAttribute("id")
      if (value) {
        if (!Object.keys(newSelections).includes(value)) {
          const display = option.textContent
          newSelections[value] = display
          this._renderSelection(value, display)
          this._markSelected(option, { selected: true })
        }
        this._actingCombobox.value = ""
        this.filter({})
      }
    } else {
      const value = option.value
      delete newSelections[value]
      const realOption = this._allOptions.find(realOption => realOption.dataset.value === value)
      if (realOption) this._markSelected(realOption, { selected: false })
    }
    this.multipleSelectionsValue = newSelections
    this.hiddenFieldTarget.value = JSON.stringify(Object.keys(this.multipleSelectionsValue))
    this._dispatchSelectionEvent({})
  }

  _selectNewForMultiple(query) {
    console.log('TODO: _selectNewForMultiple', { query })
  }

  _preselectMultipleOption() {
    if (this._allOptions.length < 1000) {
      const selectedValues = Object.keys(this.multipleSelectionsValue)

      if (selectedValues.length > 0) {
        const options = this._allOptions.filter(option => selectedValues.includes(option.dataset.value))
        options.forEach(option => this._markSelected(option, { selected: true }))
      }
    }
  }
}
