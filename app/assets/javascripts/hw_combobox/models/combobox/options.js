import Combobox from "hw_combobox/models/combobox/base"
import { unselected, visible } from "hw_combobox/helpers"

Combobox.Options = Base => class extends Base {
  _resetOptionsSilently() {
    this._resetOptions(this._deselect.bind(this))
  }

  _resetOptionsAndNotify() {
    this._resetOptions(this._deselectAndNotify.bind(this))
  }

  _resetOptions(deselectionStrategy) {
    this._setFieldName(this.originalNameValue)
    deselectionStrategy()
  }

  get _allowNew() {
    return !!this.nameWhenNewValue
  }

  get _allOptions() {
    return Array.from(this._allOptionElements)
  }

  get _allOptionElements() {
    return this._actingListbox.querySelectorAll(`[${this.filterableAttributeValue}]`)
  }

  get _unselectedOptionElements() {
    return [ ...this._allOptionElements ].filter(unselected)
  }

  get _visibleOptionElements() {
    const optionElements = this.isMultiple() ? this._unselectedOptionElements : this._allOptionElements
    return [ ...optionElements ].filter(visible)
  }

  get _selectedOptionElement() {
    return this._actingListbox.querySelector("[role=option][aria-selected=true]")
  }

  get _selectedOptionIndex() {
    return [ ...this._visibleOptionElements ].indexOf(this._selectedOptionElement)
  }

  get _isUnjustifiablyBlank() {
    const valueIsMissing = !this._fieldValue
    const noBlankOptionSelected = !this._selectedOptionElement

    return valueIsMissing && noBlankOptionSelected
  }

  get _navigatedOptionElement() {
    if (this.isMultiple()) {
      return this._actingListbox.querySelector("[role=option][aria-current=true]")
    } else {
      return this._selectedOptionElement
    }
  }

  get _navigatedOptionIndex() {
    return [ ...this._visibleOptionElements ].indexOf(this._navigatedOptionElement)
  }
}
