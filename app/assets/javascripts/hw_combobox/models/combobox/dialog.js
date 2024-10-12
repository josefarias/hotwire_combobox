import Combobox from "hw_combobox/models/combobox/base"

Combobox.Dialog = Base => class extends Base {
  rerouteListboxStreamToDialog({ detail: { newStream } }) {
    if (newStream.target == this.listboxTarget.id && this._dialogIsOpen) {
      newStream.setAttribute("target", this.dialogListboxTarget.id)
    }
  }

  _connectDialog() {
    if (window.visualViewport) {
      window.visualViewport.addEventListener("resize", this._resizeDialog)
    }
  }

  _disconnectDialog() {
    if (window.visualViewport) {
      window.visualViewport.removeEventListener("resize", this._resizeDialog)
    }
  }

  _moveArtifactsToDialog() {
    this.dialogComboboxTarget.value = this._fullQuery

    this._actingCombobox = this.dialogComboboxTarget
    this._actingListbox = this.dialogListboxTarget

    this.dialogListboxTarget.append(...this.listboxTarget.children)
  }

  _moveArtifactsInline() {
    this.comboboxTarget.value = this._fullQuery

    this._actingCombobox = this.comboboxTarget
    this._actingListbox = this.listboxTarget

    this.listboxTarget.append(...this.dialogListboxTarget.children)
  }

  _resizeDialog = () => {
    if (window.visualViewport) {
      this.dialogTarget.style.setProperty("--hw-visual-viewport-height", `${window.visualViewport.height}px`)
    }
  }

  // After closing a dialog, focus returns to the last focused element.
  // +preventFocusingComboboxAfterClosingDialog+ focuses a placeholder element before opening
  // the dialog, so that the combobox is not focused again after closing, which would reopen.
  _preventFocusingComboboxAfterClosingDialog() {
    this.dialogFocusTrapTarget.focus()
  }

  get _isSmallViewport() {
    return window.matchMedia(`(max-width: ${this.smallViewportMaxWidthValue})`).matches
  }

  get _dialogIsOpen() {
    return this.dialogTarget.open
  }
}
