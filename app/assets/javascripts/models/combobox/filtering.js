
import Combobox from "models/combobox/base"
import { applyFilter, nextFrame, debounce } from "helpers"
import { get } from "@rails/request.js"

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

    this._afterTurboStreamRender(() => this._commitFilter(q, event))
  }

  _filterSync(event) {
    const query = this._actingCombobox.value.trim()

    this.open()

    this._allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

    this._commitFilter(query, event)
  }

  _commitFilter(query, event) {
    const isDeleting = event.inputType === "deleteContentBackward"

    this._toggleEmptyClass()

    if (this._isValidNewOption(query, { ignoreAutocomplete: isDeleting })) {
      this._selectNew(query)
    } else if (isDeleting) {
      this._deselect()
    } else {
      this._select(this._visibleOptionElements[0])
    }
  }

  async _afterTurboStreamRender(callback) {
    await nextFrame()
    callback()
  }
}
