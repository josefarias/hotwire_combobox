import Combobox from "hw_combobox/models/combobox/base"
import { cancel } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

Combobox.Multiselect = Base => class extends Base {
  navigateChip(event) {
    this._chipKeyHandlers[event.key]?.call(this, event)
  }

  removeChip({ currentTarget, params }) {
    const option = this._optionElementWithValue(params.value)

    this._markNotSelected(option)
    this._markNotMultiselected(option)
    this._removeFromFieldValue(params.value)
    this._filter("hw:multiselectSync")

    currentTarget.closest("[data-hw-combobox-chip]").remove()

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

  _createChip() {
    if (!this._isMultiselect) return

    this._beforeClearingMultiselectQuery(async (display, value) => {
      this._fullQuery = ""
      this._filter("hw:multiselectSync")

      await get(this.selectionChipSrcValue, {
        responseKind: "turbo-stream",
        query: {
          for_id: this.element.dataset.asyncId,
          combobox_value: value,
          display_value: display
        }
      })

      this._addToFieldValue(value)
    })
  }

  _beforeClearingMultiselectQuery(callback) {
    const display = this.hiddenFieldTarget.dataset.displayForMultiselect
    const value = this.hiddenFieldTarget.dataset.valueForMultiselect

    if (value && !this._fieldValue.has(value)) {
      callback(display, value)
    }

    this.hiddenFieldTarget.dataset.displayForMultiselect = ""
    this.hiddenFieldTarget.dataset.valueForMultiselect = ""
  }

  _resetMultiselectionMarks() {
    if (!this._isMultiselect) return

    this._fieldValueArray.forEach(value => {
      const option = this._optionElementWithValue(value)
      option.setAttribute("data-multiselected", "")
      option.hidden = true
    })
  }

  _markNotMultiselected(option) {
    if (!this._isMultiselect) return

    option.removeAttribute("data-multiselected")
    option.hidden = false
  }

  _addToFieldValue(value) {
    let newValue = this._fieldValue

    newValue.add(String(value))
    this.hiddenFieldTarget.value = Array.from(newValue).join(",")

    if (this._isSync) this._resetMultiselectionMarks()
  }

  _removeFromFieldValue(value) {
    let newValue = this._fieldValue

    newValue.delete(String(value))
    this.hiddenFieldTarget.value = Array.from(newValue).join(",")

    if (this._isSync) this._resetMultiselectionMarks()
  }

  _focusLastChipDismisser() {
    this.chipDismisserTargets[this.chipDismisserTargets.length - 1].focus()
  }

  get _isMultiselect() {
    return this.hasSelectionChipSrcValue
  }

  get _isSingleSelect() {
    return !this._isMultiselect
  }
}
