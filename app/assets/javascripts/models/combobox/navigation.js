import Combobox from "models/combobox/base"
import { cancel } from "helpers"

Combobox.Navigation = Base => class extends Base {
  navigate(event) {
    if (this._autocompletesList) {
      this._keyHandlers[event.key]?.call(this, event)
    }
  }

  _keyHandlers = {
    ArrowUp: (event) => {
      this._selectIndex(this._selectedOptionIndex - 1)
      cancel(event)
    },
    ArrowDown: (event) => {
      this._selectIndex(this._selectedOptionIndex + 1)
      cancel(event)
    },
    Home: (event) => {
      this._selectIndex(0)
      cancel(event)
    },
    End: (event) => {
      this._selectIndex(this._visibleOptionElements.length - 1)
      cancel(event)
    },
    Enter: (event) => {
      this.close()
      this._actingCombobox.blur()
      cancel(event)
    },
    Escape: (event) => {
      this.close()
      this._actingCombobox.blur()
      cancel(event)
    }
  }
}
