import Combobox from "hw_combobox/models/combobox/base"

Combobox.Validity = Base => class extends Base {
  _markValid() {
    if (this._valueIsInvalid) return

    if (this.hasInvalidClass) {
      this._actingCombobox.classList.remove(this.invalidClass)
    }

    this._actingCombobox.removeAttribute("aria-invalid")
    this._actingCombobox.removeAttribute("aria-errormessage")

    this._dispatchValidEvent()
  }

  _markInvalid() {
    if (this._valueIsValid) return

    if (this.hasInvalidClass) {
      this._actingCombobox.classList.add(this.invalidClass)
    }

    this._actingCombobox.setAttribute("aria-invalid", true)
    this._actingCombobox.setAttribute("aria-errormessage", `Please select a valid option for ${this._actingCombobox.name}`)

    this._dispatchInvalidEvent()
  }

  get _valueIsValid() {
    return !this._valueIsInvalid
  }

  get _valueIsInvalid() {
    const isRequiredAndEmpty = this._actingCombobox.required && !this.hiddenFieldTarget.value
    return isRequiredAndEmpty
  }
}
