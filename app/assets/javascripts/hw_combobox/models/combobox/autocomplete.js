import Combobox from "hw_combobox/models/combobox/base"
import { startsWith } from "hw_combobox/helpers"

Combobox.Autocomplete = Base => class extends Base {
  _connectListAutocomplete() {
    if (!this._autocompletesList) {
      this._visuallyHideListbox()
    }
  }

  _autocompleteWith(option, { force }) {
    if (!this._autocompletesInline && !force) return

    const typedValue = this._typedQuery
    const autocompletedValue = option.getAttribute(this.autocompletableAttributeValue)

    if (force) {
      this._fullQuery = autocompletedValue
      this._actingCombobox.setSelectionRange(autocompletedValue.length, autocompletedValue.length)
    } else if (startsWith(autocompletedValue, typedValue)) {
      this._fullQuery = autocompletedValue
      this._actingCombobox.setSelectionRange(typedValue.length, autocompletedValue.length)
    }
  }

  // +visuallyHideListbox+ hides the listbox from the user,
  // but makes it still searchable by JS.
  _visuallyHideListbox() {
    this.listboxTarget.style.display = "none"
  }

  get _isExactAutocompleteMatch() {
    return this._immediatelyAutocompletableValue === this._fullQuery
  }

  // All `_isExactAutocompleteMatch` matches are `_isPartialAutocompleteMatch` matches
  // but not all `_isPartialAutocompleteMatch` matches are `_isExactAutocompleteMatch` matches.
  get _isPartialAutocompleteMatch() {
    return !!this._immediatelyAutocompletableValue &&
      startsWith(this._immediatelyAutocompletableValue, this._fullQuery)
  }

  get _autocompletesList() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "list"
  }

  get _autocompletesInline() {
    return this.autocompleteValue === "both" || this.autocompleteValue === "inline"
  }

  get _immediatelyAutocompletableValue() {
    return this._ensurableOption?.getAttribute(this.autocompletableAttributeValue)
  }
}
