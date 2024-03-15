import Combobox from "hw_combobox/models/combobox/base"
import { cancel, wrapAroundAccess } from "hw_combobox/helpers"

Combobox.Navigation = Base => class extends Base {
  navigate(event) {
    if (this._autocompletesList) {
      this._keyHandlers[event.key]?.call(this, event)
    }
  }

  _keyHandlers = {
    ArrowUp: (event) => {
      this._navigateToIndex(this._navigatedOptionIndex - 1)
      cancel(event)
    },
    ArrowDown: (event) => {
      this._navigateToIndex(this._navigatedOptionIndex + 1)
      cancel(event)
    },
    Home: (event) => {
      this._navigateToIndex(0)
      cancel(event)
    },
    End: (event) => {
      this._navigateToIndex(this._visibleOptionElements.length - 1)
      cancel(event)
    },
    Enter: (event) => {
      if (this.isMultiple()) {
        const currentIndex = this._navigatedOptionIndex
        this._selectNavigatedOption()
        this._navigateToIndex(currentIndex)
        this._actingCombobox.focus()
      } else {
        this.close()
        this._actingCombobox.blur()
      }
      cancel(event)
    },
    Escape: (event) => {
      this.close()
      this._actingCombobox.blur()
      cancel(event)
    }
  }

  _navigateToIndex(index) {
    const option = wrapAroundAccess(this._visibleOptionElements, index)
    if (this.isMultiple()) {
      this._navigateMultiple(option)
    } else {
      this._selectAndAutocompleteFullQuery(option)
    }
  }

  _navigateMultiple(option) {
    if (!option) return

    this._removeCurrentNavigation(this._navigatedOptionElement)
    option.setAttribute('aria-current', true)
    if (this.hasNavigatedClass) {
      option.classList.toggle(this.navigatedClass, true)
    }
    option.scrollIntoView({ block: "nearest" })
  }

  _removeCurrentNavigation(option) {
    if (!option) return

    if (this.hasNavigatedClass) {
      option.classList.toggle(this.navigatedClass, false)
    }
    option.removeAttribute('aria-current')
  }

  _selectNavigatedOption() {
    const option = this._navigatedOptionElement
    if (option) {
      if (this.isMultiple()) {
        this._addSelection(option)
      } else {
        this._select(option)
      }
      this._removeCurrentNavigation(option)
    }
  }
}
