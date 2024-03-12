import Combobox from "hw_combobox/models/combobox/base"
import { dispatch } from "hw_combobox/helpers"

Combobox.Events = Base => class extends Base {
  _dispatchSelectionEvent({ isNew }) {
    dispatch("hw-combobox:selection", { target: this.element, detail: { ...this._eventableDetails, isNew } })
  }

  _dispatchClosedEvent() {
    dispatch("hw-combobox:closed", { target: this.element, detail: this._eventableDetails })
  }

  get _eventableDetails() {
    return {
      value: this.hiddenFieldTarget.value,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this.hiddenFieldTarget.name,
      isValid: this._valueIsValid
    }
  }
}
