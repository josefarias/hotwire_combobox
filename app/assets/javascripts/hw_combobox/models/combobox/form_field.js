import Combobox from "hw_combobox/models/combobox/base"

Combobox.FormField = Base => class extends Base {
  get _fieldValue() {
    if (this._isMultiselect) {
      const currentValue = this.hiddenFieldTarget.value
      const arrayFromValue = currentValue ? currentValue.split(",") : []

      return new Set(arrayFromValue)
    } else {
      return this.hiddenFieldTarget.value
    }
  }

  get _fieldValueString() {
    if (this._isMultiselect) {
      return this._fieldValueArray.join(",")
    } else {
      return this.hiddenFieldTarget.value
    }
  }

  get _incomingFieldValueString() {
    if (this._isMultiselect) {
      const array = this._fieldValueArray

      if (this.hiddenFieldTarget.dataset.valueForMultiselect) {
        array.push(this.hiddenFieldTarget.dataset.valueForMultiselect)
      }

      return array.join(",")
    } else {
      return this.hiddenFieldTarget.value
    }
  }

  get _fieldValueArray() {
    if (this._isMultiselect) {
      return Array.from(this._fieldValue)
    } else {
      return [ this.hiddenFieldTarget.value ]
    }
  }

  get _currentSelectionValue() {
    if (this._isMultiselect) {
      return this.hiddenFieldTarget.dataset.valueForMultiselect || ""
    } else {
      return this.hiddenFieldTarget.value
    }
  }

  set _fieldValue(value) {
    if (this._isMultiselect) {
      this.hiddenFieldTarget.dataset.valueForMultiselect = value?.replace(/,/g, "")
      this.hiddenFieldTarget.dataset.displayForMultiselect = this._fullQuery
    } else {
      this.hiddenFieldTarget.value = value
      this._syncRequired()
    }
  }

  get _hasEmptyCurrentSelection() {
    if (this._isMultiselect) {
      return this.hiddenFieldTarget.dataset.valueForMultiselect == "" || this.hiddenFieldTarget.dataset.valueForMultiselect == "undefined"
    } else {
      return this.hiddenFieldTarget.value === ""
    }
  }

  get _hasCurrentSelection() {
    return !this._hasEmptyCurrentSelection
  }

  get _isBlank() {
    return this.hiddenFieldTarget.value === ""
  }

  get _fieldName() {
    return this.hiddenFieldTarget.name
  }

  set _fieldName(value) {
    this.hiddenFieldTarget.name = value
  }
}
