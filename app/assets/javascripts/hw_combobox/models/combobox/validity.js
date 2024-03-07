import Combobox from "hw_combobox/models/combobox/base"

Combobox.Validity = Base => class extends Base {
  _markValid() {
    if (this._valueIsInvalid) return

    this._forAllComboboxes(combobox => {
      if (this.hasInvalidClass) {
        combobox.classList.remove(this.invalidClass)
      }

      combobox.removeAttribute("aria-invalid")
      combobox.removeAttribute("aria-errormessage")
    })
  }

  _markInvalid() {
    if (this._valueIsValid) return

    this._forAllComboboxes(combobox => {
      if (this.hasInvalidClass) {
        combobox.classList.add(this.invalidClass)
      }

      combobox.setAttribute("aria-invalid", true)
      combobox.setAttribute("aria-errormessage", `Please select a valid option for ${combobox.name}`)
    })
  }

  get _valueIsValid() {
    return !this._valueIsInvalid
  }

  get _valueIsInvalid() {
    const isRequiredAndEmpty = this._actingCombobox.required && !this.hiddenFieldTarget.value
    return isRequiredAndEmpty
  }
}
