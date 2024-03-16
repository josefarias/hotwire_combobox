import Combobox from "hw_combobox/models/combobox/base"
import { cancel } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

Combobox.Multiselect = Base => class extends Base {
  async createChip() {
    if (!this._isMultiselect || !this._fieldValue) return

    await get(this.selectionChipSrcValue, {
      responseKind: "turbo-stream",
      query: {
        for_id: this.element.dataset.asyncId,
        combobox_value: this._fieldValue
      }
    })

    this._clearQuery()

    if (!this._isSmallViewport) {
      this.openByFocusing()
    }
  }

  navigateChip(event) {
    this._chipKeyHandlers[event.key]?.call(this, event)
  }

  removeChip(event) {
    event.currentTarget.closest("[data-hw-combobox-chip]").remove()
    console.log("removing ", event.params.value) // TODO: implement removal

    if (!this._isSmallViewport) {
      this.openByFocusing()
    }
  }

  _chipKeyHandlers = {
    Backspace: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Enter: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Space: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Escape: (event) => {
      this.openByFocusing()
      cancel(event)
    }
  }

  _focusLastChipDismisser() {
    this.chipDismisserTargets[this.chipDismisserTargets.length - 1].focus()
  }

  get _isMultiselect() {
    return this.hasSelectionChipSrcValue
  }
}
