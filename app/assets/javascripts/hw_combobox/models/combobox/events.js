import Combobox from "hw_combobox/models/combobox/base"
import { dispatch } from "hw_combobox/helpers"

Combobox.Events = Base => class extends Base {
  _dispatchSelectionEvent({ isNewAndAllowed, previousValue }) {
    if (previousValue === this._fieldValue) return

    dispatch("hw-combobox:selection", {
      target: this.element,
      detail: { ...this._eventableDetails, isNewAndAllowed, previousValue }
    })
  }

  _dispatchClosedEvent() {
    dispatch("hw-combobox:closed", {
      target: this.element,
      detail: this._eventableDetails
    })
  }

  get _eventableDetails() {
    return {
      value: this._fieldValue,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this._fieldName,
      isValid: this._valueIsValid
    }
  }
}
