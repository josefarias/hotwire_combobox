
import Combobox from "hw_combobox/models/combobox/base"
import { applyFilter, nextFrame, debounce, isDeleteEvent } from "hw_combobox/helpers"
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
    const q = this._actingCombobox.value.trim()

    await get(this.asyncSrcValue, { responseKind: "turbo-stream", query: { q } })

    this._afterTurboStreamRender(() => this._commitFilter(event))
  }

  _filterSync(event) {
    const query = this._actingCombobox.value.trim()

    this.open()

    this._allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

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

  async _afterTurboStreamRender(callback) {
    await nextFrame()
    callback()
  }

  get _isQueried() {
    return this._actingCombobox.value.length > 0
  }
}
