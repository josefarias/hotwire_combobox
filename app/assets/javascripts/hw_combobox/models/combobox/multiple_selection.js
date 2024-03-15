import Combobox from "hw_combobox/models/combobox/base"

Combobox.MultipleSelection = Base => class extends Base {
  removeSelection(event) {
    const element = event.target
    const value = element.getAttribute("data-value")
    this._commitMultipleSelection({ value }, { selected: false })
    element.parentElement.remove()
    this._markInvalid()
  }

  _connectMultipleSelection() {
    this._renderSelections()
    this._setMultipleValue()
  }

  _renderSelections() {
    this._multipleSelectionValues().forEach((selectedValue) => {
      this._renderSelection(selectedValue, this.multipleSelectionsValue[selectedValue])
    })
  }

  _renderSelection(value, display) {
    const selectionWrapper = document.createElement("div")
    selectionWrapper.id = value
    selectionWrapper.classList.add("hw-combobox__multiple_selection")
    const text = document.createElement("div")
    text.textContent = display
    const deselector = document.createElement("div")
    deselector.classList.add("hw-combobox__multiple_selection__remove")
    deselector.setAttribute("data-action", "click->hw-combobox#removeSelection")
    deselector.setAttribute("data-value", value)
    selectionWrapper.appendChild(text)
    selectionWrapper.appendChild(deselector)
    this.innerWrapperTarget.insertBefore(selectionWrapper, this.comboboxTarget)
  }

  _setMultipleValue() {
    this._setFieldValue(JSON.stringify(this._multipleSelectionValues()))
  }

  _multipleSelectionValues() {
    if (this.hasMultipleSelectionsValue) {
      return Object.keys(this.multipleSelectionsValue)
    }
    return []
  }

  _addSelection(option) {
    this._commitMultipleSelection(option, { selected: true })
    this._markValid()
  }

  _commitMultipleSelection(option, { selected }) {
    const previousValue = this._fieldValue
    const newSelections = { ...this.multipleSelectionsValue }
    if (selected) {
      const value = option.getAttribute("id")
      if (value) {
        if (!Object.keys(newSelections).includes(value)) {
          const display = option.textContent
          newSelections[value] = display
          this._renderSelection(value, display)
          this._markSelected(option)
        }
        this._actingCombobox.value = ""
        this._fullQuery = ""
      }
    } else {
      const value = option.value
      delete newSelections[value]
      const realOption = this._findOptionByValue(value)
      if (realOption) this._markNotSelected(realOption)
    }
    this.multipleSelectionsValue = newSelections
    this._setMultipleValue()
    this._dispatchSelectionEvent({ isNewAndAllowed: false, previousValue })
  }

  _selectNewForMultiple(query) {
    console.log('TODO: _selectNewForMultiple', { query })
  }

  _preselectMultiple() {
    if (this._allOptions.length < 1000) {
      const selectedValues = this._multipleSelectionValues()
      if (selectedValues.length > 0) {
        const options = this._allOptions.filter(option => selectedValues.includes(option.dataset.value))
        options.forEach(option => this._markSelected(option))
      }
    }
  }
}
