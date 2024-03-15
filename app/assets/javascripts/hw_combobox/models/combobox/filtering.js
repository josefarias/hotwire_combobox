
import Combobox from "hw_combobox/models/combobox/base"
import { applyFilter, debounce, unselectedPortion } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

Combobox.Filtering = Base => class extends Base {
  filterAndSelect(event) {
    this._filter(event)

    if (this._isSync) {
      this._selectBasedOnQuery(event)
    } else {
      // noop, async selection is handled by stimulus callbacks
    }
  }

  _initializeFiltering() {
    this._debouncedFilterAsync = debounce(this._debouncedFilterAsync.bind(this))
  }

  _filter(event) {
    if (this._isAsync) {
      this._debouncedFilterAsync(event)
    } else {
      this._filterSync()
    }

    this._actingCombobox.toggleAttribute("data-queried", this._isQueried)
  }

  _debouncedFilterAsync(event) {
    this._filterAsync(event)
  }

  async _filterAsync(event) {
    const query = {
      q: this._fullQuery,
      input_type: event.inputType,
      for_id: this.element.dataset.asyncId
    }

    await get(this.asyncSrcValue, { responseKind: "turbo-stream", query })
  }

  _filterSync() {
    this.open()
    this._allOptionElements.forEach(applyFilter(this._fullQuery, { matching: this.filterableAttributeValue }))
  }

  _clearQuery() {
    this._fullQuery = ""
    this.filterAndSelect({ inputType: "deleteContentBackward" })
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
