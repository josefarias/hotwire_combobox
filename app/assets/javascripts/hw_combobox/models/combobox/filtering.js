
import Combobox from "hw_combobox/models/combobox/base"
import { applyFilter, debounce, unselectedPortion } from "hw_combobox/helpers"
import { get } from "hw_combobox/vendor/requestjs"

const UNSPECIFIED_INPUT_TYPE = "hw:unspecifiedInput"

Combobox.Filtering = Base => class extends Base {
  prepareToFilter({ key }) {
    // Some soft keyboards and autofill overlays emit keydown events without a `key`.
    const intendsToFilter = key?.match(/^[a-zA-Z0-9]$|^ArrowDown$/)

    if (this._isClosed && intendsToFilter) {
      this.open() // `.open()` sets the appropriate state so the combobox knows it’s open.
      this._expand() // `.open()` will call `._expand()` via stimulus callbacks, but we’re calling it inline so it happens immediately.
    }
  }

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
    this._isPending = false
    this._debouncedFilterAsync = debounce(this._debouncedFilterAsync.bind(this), this.debounceIntervalValue)
  }

  _filter(inputType) {
    if (this._isAsync) {
      this._dispatchPendingEvent()
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
    this._abortSupersededFilter()
    this._filterAbortController = new AbortController()

    const query = {
      q: this._fullQuery,
      input_type: inputType || UNSPECIFIED_INPUT_TYPE,
      for_id: this.element.dataset.asyncId
    }

    try {
      await get(this.asyncSrcValue, {
        responseKind: "turbo-stream", query, signal: this._filterAbortController.signal
      })
    } catch (error) {
      if (error.name !== "AbortError") {
        this._dispatchSettledEvent()
        throw error
      }
    }
  }

  _abortSupersededFilter() {
    this._filterAbortController?.abort()
    this._filterAbortController = null
  }

  _filterSync() {
    this._allFilterableOptionElements.forEach(applyFilter(this._fullQuery, { matching: this.filterableAttributeValue }))
  }

  _clearQuery() {
    const previousValue = this._incomingFieldValueString

    this._resetQuery()
    this._dispatchSelectionEvent(previousValue)
  }

  _resetQuery() {
    this._fullQuery = ""
    this._abortSupersededFilter()
    this._resetOptionsAndNotify()
    this._filter("deleteContentBackward")
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
