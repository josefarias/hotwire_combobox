import Combobox from "models/combobox/base"

Combobox.Validity = Base => class extends Base {
  _markValid() {
    if (this._valueIsInvalid) return

    if (this.hasInvalidClass) {
      this.comboboxTarget.classList.remove(this.invalidClass)
    }

    this.comboboxTarget.removeAttribute("aria-invalid")
    this.comboboxTarget.removeAttribute("aria-errormessage")
  }

  _markInvalid() {
    if (this._valueIsValid) return

    if (this.hasInvalidClass) {
      this.comboboxTarget.classList.add(this.invalidClass)
    }

    this.comboboxTarget.setAttribute("aria-invalid", true)
    this.comboboxTarget.setAttribute("aria-errormessage", `Please select a valid option for ${this.comboboxTarget.name}`)
  }

  get _valueIsValid() {
    return !this._valueIsInvalid
  }

  get _valueIsInvalid() {
    const isRequiredAndEmpty = this.comboboxTarget.required && !this.hiddenFieldTarget.value
    return isRequiredAndEmpty
  }
}
