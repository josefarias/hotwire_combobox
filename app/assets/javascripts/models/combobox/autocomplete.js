import Combobox from "models/combobox/base"
import { startsWith } from "helpers"

Combobox.Autocomplete = Base => class extends Base {
  _initializeListAutocomplete() {
    if (!this._autocompletesList) {
      this._visuallyHideListbox()
    }
  }

  _maybeAutocompleteWith(option, { force }) {
    if (!this._autocompletesInline && !force) return

    const typedValue = this._actingCombobox.value
    const autocompletedValue = option.getAttribute(this.autocompletableAttributeValue)

    if (force) {
      this._actingCombobox.value = autocompletedValue
      this._actingCombobox.setSelectionRange(autocompletedValue.length, autocompletedValue.length)
    } else if (startsWith(autocompletedValue, typedValue)) {
      this._actingCombobox.value = autocompletedValue
      this._actingCombobox.setSelectionRange(typedValue.length, autocompletedValue.length)
    }
  }

  // +visuallyHideListbox+ makes it so the listbox is hidden to the user when
  // not autocompleting lists, but still searchable by JS.
  _visuallyHideListbox() {
    this.listboxTarget.style.display = "none"
  }

  get _autocompletesList() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "list"
  }

  get _autocompletesInline() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "inline"
  }
}
