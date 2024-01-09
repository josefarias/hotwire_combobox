import Combobox from "models/combobox/base"
import { wrapAroundAccess } from "helpers"

Combobox.Selection = Base => class extends Base {
  selectOption(event) {
    this._select(event.currentTarget)
    this.close()
  }

  _initializeSelection() {
    if (this.hiddenFieldTarget.value) {
      this._selectOptionByValue(this.hiddenFieldTarget.value)
    }
  }

  _select(option, { force = false } = {}) {
    this._resetOptions()

    if (option) {
      if (this.hasSelectedClass) option.classList.add(this.selectedClass)
      if (this.hasInvalidClass) this.comboboxTarget.classList.remove(this.invalidClass)
      this.comboboxTarget.removeAttribute("aria-invalid")
      this.comboboxTarget.removeAttribute("aria-errormessage")

      this._maybeAutocompleteWith(option, { force })
      this._executeSelect(option, { selected: true })
    } else {
      if (this._valueIsInvalid) {
        if (this.hasInvalidClass) this.comboboxTarget.classList.add(this.invalidClass)

        this.comboboxTarget.setAttribute("aria-invalid", true)
        this.comboboxTarget.setAttribute("aria-errormessage", `Please select a valid option for ${this.comboboxTarget.name}`)
      }
    }
  }

  _executeSelect(option, { selected }) {
    if (selected) {
      option.setAttribute("aria-selected", true)
      this.hiddenFieldTarget.value = option.dataset.value
    } else {
      option.setAttribute("aria-selected", false)
      this.hiddenFieldTarget.value = null
    }
  }

  _deselect(option) {
    if (option) {
      if (this.hasSelectedClass) option.classList.remove(this.selectedClass)
      this._executeSelect(option, { selected: false })
    }
  }

  _selectNew(query) {
    this._resetOptions()
    this.hiddenFieldTarget.value = query
    this.hiddenFieldTarget.name = this.nameWhenNewValue
  }

  _selectIndex(index) {
    const option = wrapAroundAccess(this._visibleOptionElements, index)
    this._select(option, { force: true })
  }

  _selectOptionByValue(value) {
    this._allOptions.find(option => option.dataset.value === value)?.click()
  }

  get _valueIsInvalid() {
    const isRequiredAndEmpty = this.comboboxTarget.required && !this.hiddenFieldTarget.value
    return isRequiredAndEmpty
  }
}
