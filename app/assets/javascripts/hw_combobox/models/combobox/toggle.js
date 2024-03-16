import Combobox from "hw_combobox/models/combobox/base"
import { disableBodyScroll, enableBodyScroll } from "hw_combobox/vendor/bodyScrollLock"

Combobox.Toggle = Base => class extends Base {
  open() {
    this.expandedValue = true
  }

  openByFocusing() {
    this._actingCombobox.focus()
  }

  close() {
    if (this._isOpen) {
      this._lockInSelection()
      this._clearInvalidQuery()

      this.expandedValue = false

      this._dispatchClosedEvent()
    }
  }

  toggle() {
    if (this.expandedValue) {
      this.close()
    } else {
      this.openByFocusing()
    }
  }

  closeOnClickOutside(event) {
    const target = event.target

    if (!this._isOpen) return
    if (this.mainWrapperTarget.contains(target) && !this._isDialogDismisser(target)) return
    if (this._withinElementBounds(event)) return

    this.close()
  }

  closeOnFocusOutside({ target }) {
    if (!this._isOpen) return
    if (this.element.contains(target)) return

    this.close()
  }

  clearOrToggleOnHandleClick() {
    if (this._isQueried) {
      this._clearQuery()
      this._actingCombobox.focus()
    } else {
      this.toggle()
    }
  }

  // Some browser extensions like 1Password overlay elements on top of the combobox.
  // Hovering over these elements emits a click event for some reason.
  // These events don't contain any telling information, so we use `_withinElementBounds`
  // as an alternative to check whether the click is legitimate.
  _withinElementBounds(event) {
    const { left, right, top, bottom } = this.mainWrapperTarget.getBoundingClientRect()
    const { clientX, clientY } = event

    return clientX >= left && clientX <= right && clientY >= top && clientY <= bottom
  }

  _isDialogDismisser(target) {
    return target.closest("dialog") && target.role != "combobox"
  }

  _expand() {
    if (this._preselectOnExpansion) this._preselect()

    if (this._autocompletesList && this._isSmallViewport) {
      this._openInDialog()
    } else {
      this._openInline()
    }

    this._actingCombobox.setAttribute("aria-expanded", true) // needs to happen after setting acting combobox
  }

  // +._collapse()+ differs from `.close()` in that it might be called by stimulus on connect because
  // it interprets a change in `expandedValue` — whereas `.close()` is only called internally by us.
  _collapse() {
    this._actingCombobox.setAttribute("aria-expanded", false) // needs to happen before resetting acting combobox

    if (this._dialogIsOpen) {
      this._closeInDialog()
    } else {
      this._closeInline()
    }
  }

  _openInDialog() {
    this._moveArtifactsToDialog()
    this._preventFocusingComboboxAfterClosingDialog()
    this._preventBodyScroll()
    this.dialogTarget.showModal()
  }

  _openInline() {
    this.listboxTarget.hidden = false
  }

  _closeInDialog() {
    this._moveArtifactsInline()
    this.dialogTarget.close()
    this._restoreBodyScroll()
    this._actingCombobox.scrollIntoView({ block: "center" })
  }

  _closeInline() {
    this.listboxTarget.hidden = true
  }

  _preventBodyScroll() {
    disableBodyScroll(this.dialogListboxTarget)
  }

  _restoreBodyScroll() {
    enableBodyScroll(this.dialogListboxTarget)
  }

  _clearInvalidQuery() {
    if (this._isUnjustifiablyBlank) {
      this._deselect()
      this._clearQuery()
    }
  }

  get _isOpen() {
    return this.expandedValue
  }

  get _preselectOnExpansion() {
    return !this._isAsync // async comboboxes preselect based on callbacks
  }
}
