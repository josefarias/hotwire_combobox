import Combobox from "models/combobox/base"

Combobox.Toggle = Base => class extends Base {
  open() {
    this.expandedValue = true
  }

  close() {
    if (this._isOpen) {
      this._ensureSelection()
      this.expandedValue = false
    }
  }

  toggle() {
    if (this.expandedValue) {
      this.close()
    } else {
      this._openByFocusing()
    }
  }

  closeOnClickOutside({ target }) {
    if (this.element.contains(target) && !this._isDialogDismisser(target)) return

    this.close()
  }

  closeOnFocusOutside({ target }) {
    if (!this._isOpen) return
    if (this.element.contains(target)) return
    if (target.matches("main")) return

    this.close()
  }

  _ensureSelection() {
    if (!this._isValidNewOption(this._actingCombobox.value, { ignoreAutocomplete: true })) {
      this._select(this._selectedOptionElement, { force: true })
    }
  }

  _openByFocusing() {
    this._actingCombobox.focus()
  }

  _isDialogDismisser(target) {
    return target.closest("dialog") && target.role != "combobox"
  }

  async _expand() {
    if (this._autocompletesList && this._smallViewport) {
      this._openInDialog()
    } else {
      this._openInline()
    }

    this._actingCombobox.setAttribute("aria-expanded", true) // needs to happen after setting acting combobox
  }

  _collapse() {
    this._actingCombobox.setAttribute("aria-expanded", false) // needs to happen before resetting acting combobox

    if (this.dialogTarget.open) {
      this._closeInDialog()
    } else {
      this._closeInline()
    }
  }

  _openInDialog() {
    this._moveArtifactsToDialog()
    this._preventFocusingComboboxAfterClosingDialog()
    this.dialogTarget.showModal()
  }

  _openInline() {
    this.listboxTarget.hidden = false
  }

  _closeInDialog() {
    this._moveArtifactsInline()
    this.dialogTarget.close()
  }

  _closeInline() {
    this.listboxTarget.hidden = true
  }

  get _isOpen() {
    return this.expandedValue
  }
}
