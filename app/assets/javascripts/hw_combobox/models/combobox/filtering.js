
import Combobox from "hw_combobox/models/combobox/base"
import { applyFilter, debounce, unselectedPortion } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

Combobox.Filtering = Base => class extends Base {
  filterAndSelect({ inputType }) {
    this._filter(inputType)

    if (this._isSync) {
      this._selectOnQuery(inputType)
    } else {
      // noop, async selection is handled by stimulus callbacks
    }
  }

  clear(event) {
    this._clearQuery()
    this.chipDismisserTargets.forEach(el => el.click())
    if (event && !event.defaultPrevented) event.target.focus()
  }

  _initializeFiltering() {
    this._debouncedFilterAsync = debounce(this._debouncedFilterAsync.bind(this))
  }

  _filter(inputType) {
    if (this._isAsync) {
      this._debouncedFilterAsync(inputType)
    } else {
      this._filterSync()
    }

    this._markQueried()
  }

  _debouncedFilterAsync(inputType) {
    this._filterAsync(inputType)
  }

  async _filterAsync(inputType) {
    const query = {
      q: this._fullQuery,
      input_type: inputType,
      for_id: this.element.dataset.asyncId,
      callback_id: this._enqueueCallback()
    }

    await get(this.asyncSrcValue, { responseKind: "turbo-stream", query })
  }

  _filterSync() {
    this._allFilterableOptionElements.forEach(applyFilter(this._fullQuery, { matching: this.filterableAttributeValue }))
  }

  _clearQuery() {
    this._fullQuery = ""
    this.filterAndSelect({ inputType: "deleteContentBackward" })
  }

  _markQueried() {
    this._forAllComboboxes(el => el.toggleAttribute("data-queried", this._isQueried))
  }

  get _isQueried() {
    return this._fullQuery.length > 0
  }

  get _fullQuery() {
    return this._actingCombobox.value
  }

  set _fullQuery(value) {
    this._actingCombobox.value = value
  }

  get _typedQuery() {
    return unselectedPortion(this._actingCombobox)
  }
}
