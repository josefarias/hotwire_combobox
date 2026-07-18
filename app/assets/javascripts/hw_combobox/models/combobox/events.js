import Combobox from "hw_combobox/models/combobox/base"
import { dispatch } from "hw_combobox/helpers"

Combobox.Events = Base => class extends Base {
  _dispatchPreselectionEvent({ isNewAndAllowed, previousValue }) {
    if (previousValue === this._incomingFieldValueString) return

    dispatch("hw-combobox:preselection", {
      target: this.element,
      detail: { ...this._eventableDetails, isNewAndAllowed, previousValue }
    })
  }

  _dispatchSelectionEvent() {
    dispatch("hw-combobox:selection", {
      target: this.element,
      detail: this._eventableDetails
    })
  }

  _dispatchRemovalEvent({ removedDisplay, removedValue }) {
    dispatch("hw-combobox:removal", {
      target: this.element,
      detail: { ...this._eventableDetails, removedDisplay, removedValue }
    })
  }

  _dispatchRestorationEvent() {
    dispatch("hw-combobox:restoration", {
      target: this.element,
      detail: this._eventableDetails
    })
  }

  get _eventableDetails() {
    return {
      value: this._incomingFieldValueString,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this._fieldName,
      originalName: this.originalNameValue,
      isNewAndAllowed: this._isNewOptionWithPotentialMatches,
      isValid: this._valueIsValid,
      chipData: this._currentChipData
    }
  }

  get _currentChipData() {
    const value = this._currentSelectionValue
    if (!value) return null

    const option = this._optionElementWithValue(value)
    if (!option) return null

    const extras = this._chipExtrasFromOptionElement(option)
    return Object.keys(extras).length > 0 ? extras : null
  }
}
