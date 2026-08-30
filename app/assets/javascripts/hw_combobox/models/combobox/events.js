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

  // Callers decide whether anything was chosen — navigating the options is not a
  // selection, so only the acts that settle what the field would submit announce one,
  // and each one knows the value it settled away from.
  _dispatchSelectionEvent(previousValue) {
    dispatch("hw-combobox:selection", {
      target: this.element,
      detail: { ...this._eventableDetails, previousValue }
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

  _dispatchPendingEvent() {
    if (this._isPending) return

    this._isPending = true
    this._forAllComboboxes(el => el.toggleAttribute("data-pending", true))

    dispatch("hw-combobox:pending", {
      target: this.element,
      detail: this._eventableDetails
    })
  }

  _dispatchSettledEvent() {
    if (!this._isPending) return

    this._isPending = false
    this._forAllComboboxes(el => el.toggleAttribute("data-pending", false))

    dispatch("hw-combobox:settled", {
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
