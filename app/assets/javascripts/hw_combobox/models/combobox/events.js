import Combobox from "hw_combobox/models/combobox/base"
import { dispatch } from "hw_combobox/helpers"

Combobox.Events = Base => class extends Base {
  _dispatchSelectionEvent({ isNew }) {
    dispatch("hw-combobox:selection", { target: this.element, detail: { ...this._eventableState, isNew } })
  }

  _dispatchValidEvent() {
    dispatch("hw-combobox:valid", { target: this.element, detail: this._eventableState })
  }

  _dispatchInvalidEvent() {
    dispatch("hw-combobox:invalid", { target: this.element, detail: this._eventableState })
  }

  get _eventableState() {
    return {
      value: this.hiddenFieldTarget.value,
      display: this._fullQuery,
      query: this._typedQuery,
      fieldName: this.hiddenFieldTarget.name
    }
  }
}
