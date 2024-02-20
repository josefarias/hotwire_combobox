import Combobox from "hw_combobox/models/combobox/base"
import { visible, startsWith } from "hw_combobox/helpers"

Combobox.Options = Base => class extends Base {
  _resetOptions() {
    this._deselect()
    this.hiddenFieldTarget.name = this.originalNameValue
  }

  _isValidNewOption(query, { ignoreAutocomplete = false } = {}) {
    const typedValue = this._actingCombobox.value
    const autocompletedValue = this._visibleOptionElements[0]?.getAttribute(this.autocompletableAttributeValue)
    const insufficientAutocomplete = !autocompletedValue || !startsWith(autocompletedValue, typedValue)

    return query.length > 0 && this._allowNew && (ignoreAutocomplete || insufficientAutocomplete)
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

  get _visibleOptionElements() {
    return [ ...this._allOptionElements ].filter(visible)
  }

  get _selectedOptionElement() {
    return this._actingListbox.querySelector("[role=option][aria-selected=true]")
  }

  get _selectedOptionIndex() {
    return [ ...this._visibleOptionElements ].indexOf(this._selectedOptionElement)
  }
}
