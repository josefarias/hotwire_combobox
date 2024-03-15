import Combobox from "hw_combobox/models/combobox/base"
import { dispatch } from "hw_combobox/helpers"

Combobox.Events = Base => class extends Base {
  _dispatchSelectionEvent({ isNewAndAllowed, previousValue }) {
    if (previousValue !== this._value) {
      dispatch("hw-combobox:selection", {
        target: this.element,
        detail: { ...this._eventableDetails, isNewAndAllowed, previousValue }
      })
    }
  }

  _dispatchClosedEvent() {
    dispatch("hw-combobox:closed", { target: this.element, detail: this._eventableDetails })
  }

  get _eventableDetails() {
    return {
      value: this._value,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this.hiddenFieldTarget.name,
      isValid: this._valueIsValid
    }
  }
}
