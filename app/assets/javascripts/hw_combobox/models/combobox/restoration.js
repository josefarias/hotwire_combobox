import Combobox from "hw_combobox/models/combobox/base"

Combobox.Restoration = Base => class extends Base {
  restore({ fieldName, value, display } = {}) {
    if (this._isMultiselect) {
      this._restoreMultiselect({ fieldName, value })
    } else {
      this._restoreSingle({ fieldName, value, display })
    }

    this._dispatchRestorationEvent()
  }

  _restoreSingle({ fieldName, value, display }) {
    if (fieldName) this._fieldName = fieldName

    this.hiddenFieldTarget.value = value || ""
    this._fullQuery = display || ""
    this._markQueried()
    this._preselectSingle()
    this._markValid()
  }

  _restoreMultiselect({ fieldName, value }) {
    if (fieldName) this._fieldName = fieldName

    this._removeAllChips()
    this.hiddenFieldTarget.value = value || ""
    this._resetMultiselectionMarks()
    this._markMultiPreselected()

    if (value) this._buildChips(this._fieldValueString)

    this._markValid()
  }

  _removeAllChips() {
    this.element.querySelectorAll("[data-hw-combobox-chip]").forEach(chip => chip.remove())
  }
}
