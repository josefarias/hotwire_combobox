
import Combobox from "hw_combobox/models/combobox/base"
import { applyFilter, debounce, isDeleteEvent, unselectedPortion } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

Combobox.Filtering = Base => class extends Base {
  filter(event) {
    if (this._isAsync) {
      this._debouncedFilterAsync(event)
    } else {
      this._filterSync(event)
    }
  }

  _initializeFiltering() {
    this._debouncedFilterAsync = debounce(this._debouncedFilterAsync.bind(this))
  }

  _debouncedFilterAsync(event) {
    this._filterAsync(event)
  }

  async _filterAsync(event) {
    const query = { q: this._fullQuery, input_type: event.inputType }
    await get(this.asyncSrcValue, { responseKind: "turbo-stream", query })
  }

  _filterSync(event) {
    this.open()
    this._allOptionElements.forEach(applyFilter(this._fullQuery, { matching: this.filterableAttributeValue }))
    this._commitFilter(event)
  }

  _commitFilter(event) {
    if (this._shouldTreatAsNewOptionForFiltering(!isDeleteEvent(event))) {
      this._selectNew()
    } else if (isDeleteEvent(event)) {
      this._deselect()
    } else {
      this._select(this._visibleOptionElements[0])
    }
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
