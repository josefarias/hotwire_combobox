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

  _dispatchClearEvent() {
    dispatch("hw-combobox:clear", {
      target: this.element,
      detail: {
        previousValue: this._fieldValue,
        previousDisplay: this._fullQuery,
        fieldName: this._fieldName
      }
    })
  }

  get _eventableDetails() {
    return {
      value: this._incomingFieldValueString,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this._fieldName,
      isValid: this._valueIsValid
    }
  }
}
