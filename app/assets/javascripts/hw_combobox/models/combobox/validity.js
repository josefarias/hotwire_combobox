import Combobox from "hw_combobox/models/combobox/base"

Combobox.Validity = Base => class extends Base {
  // +required+ can't live on the hidden field where the value is: hidden inputs are barred from
  // constraint validation. Instead we toggle it on the visible +comboboxTarget+ to track +_hasBlankValue+.
  // https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#barred-from-constraint-validation
  _connectRequired() {
    if (!("hwComboboxRequiredByAuthor" in this.comboboxTarget.dataset)) {
      this.comboboxTarget.dataset.hwComboboxRequiredByAuthor = this.comboboxTarget.required
    }

    this._syncRequired()
  }

  _syncRequired() {
    if (this.comboboxTarget.dataset.hwComboboxRequiredByAuthor !== "true") return

    this.comboboxTarget.toggleAttribute("required", this._hasBlankValue)
  }

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

  // +_valueIsInvalid+ only checks if `comboboxTarget` (and not `_actingCombobox`) is required
  // because the `required` attribute is only forwarded to the `comboboxTarget` element
  get _valueIsInvalid() {
    const isRequiredAndEmpty = this.comboboxTarget.required && this._hasBlankValue
    return isRequiredAndEmpty
  }
}
