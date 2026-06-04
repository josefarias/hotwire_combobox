import Combobox from "hw_combobox/models/combobox/base"
import { cancel } from "hw_combobox/helpers"
import { post } from "hw_combobox/vendor/requestjs"

const CHIP_PLACEHOLDER_REGEX = /\{\{(\w+)\}\}/g
const CHIP_DATA_ATTR_PREFIX = "data-chip-"

Combobox.Multiselect = Base => class extends Base {
  navigateChip(event) {
    this._chipKeyHandlers[event.key]?.call(this, event)
  }

  removeChip({ currentTarget, params }) {
    let display
    const option = this._optionElementWithValue(params.value)

    if (option) {
      display = option.getAttribute(this.autocompletableAttributeValue)
      this._markNotSelected(option)
      this._markNotMultiselected(option)
    } else {
      display = this._prefilledChipFor(params.value)?.display || params.value
    }

    this._removeFromFieldValue(params.value)
    this._filter("hw:multiselectSync")

    currentTarget.closest("[data-hw-combobox-chip]").remove()

    if (!this._isSmallViewport) {
      this.open()
    }

    this._announceToScreenReader(display, "removed")
    this._dispatchRemovalEvent({ removedDisplay: display, removedValue: params.value })
  }

  hideChipsForCache() {
    this.element.querySelectorAll("[data-hw-combobox-chip]").forEach(chip => chip.hidden = true)
  }

  _chipKeyHandlers = {
    Backspace: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Enter: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Space: (event) => {
      this.removeChip(event)
      cancel(event)
    },
    Escape: (event) => {
      this.open()
      cancel(event)
    }
  }

  _connectMultiselect() {
    if (!this._isMultiPreselected) {
      this._preselectMultiple()
      this._markMultiPreselected()
    }
  }

  _createChip() {
    if (!this._isMultiselect) return

    this._beforeClearingMultiselectQuery((display, value) => {
      this._fullQuery = ""

      this._filter("hw:multiselectSync")
      this._buildChips(value)
      this._addToFieldValue(value)

      this._announceToScreenReader(display, "multi-selected. Press Shift + Tab, then Enter to remove.")
    })
  }

  _buildChips(values) {
    if (this._hasChipTemplate) {
      this._renderChipsClientSide(values)
    } else if (this.hasSelectionChipSrcValue) {
      this._requestChips(values)
    }
  }

  async _requestChips(values) {
    await post(this.selectionChipSrcValue, {
      responseKind: "turbo-stream",
      query: {
        for_id: this.element.dataset.asyncId,
        combobox_values: values
      }
    })
  }

  _renderChipsClientSide(values) {
    const valueList = Array.isArray(values) ? values : String(values).split(",")

    valueList.filter(value => value.length > 0).forEach(value => {
      this._renderChipForValue(value)
    })
  }

  _renderChipForValue(value) {
    const fragment = this._chipTemplate.content.cloneNode(true)

    this._substituteChipPlaceholders(fragment, this._chipMappingFor(value))

    const wrapper = document.createElement("div")
    wrapper.setAttribute("data-hw-combobox-chip", "")
    wrapper.appendChild(fragment)

    const input = document.getElementById(this.element.dataset.asyncId)
    if (input) input.parentNode.insertBefore(wrapper, input)
  }

  _chipMappingFor(value) {
    const data = this._chipDataFromOption(value)
      || this._chipDataFromRestoredChip(value)
      || this._chipDataFromPrefilledChip(value)
      || { display: String(value) }
    return { value: String(value), ...data }
  }

  _chipDataFromOption(value) {
    const option = this._optionElementWithValue(value)
    if (!option) return null

    return {
      display: option.getAttribute(this.autocompletableAttributeValue) || "",
      ...this._chipExtrasFromOptionElement(option)
    }
  }

  _chipExtrasFromOptionElement(option) {
    const extras = {}

    for (const attr of option.attributes) {
      if (attr.name.startsWith(CHIP_DATA_ATTR_PREFIX)) {
        const placeholder = attr.name.slice(CHIP_DATA_ATTR_PREFIX.length).replace(/-/g, "_")
        extras[placeholder] = attr.value
      }
    }

    return extras
  }

  _chipDataFromRestoredChip(value) {
    const restoredChip = this._restoredChipFor(value)
    if (!restoredChip) return null

    return { display: restoredChip.display || "", ...(restoredChip.chip_data || {}) }
  }

  _chipDataFromPrefilledChip(value) {
    const prefilledChip = this._prefilledChipFor(value)
    if (!prefilledChip) return null

    return { display: prefilledChip.display || "", ...(prefilledChip.chip_data || {}) }
  }

  _restoredChipFor(value) {
    if (!this._restoredChips) return null

    return this._restoredChips.find(restoredChip => String(restoredChip.value) === String(value))
  }

  _prefilledChipFor(value) {
    if (!this.hasPrefilledChipsValue) return null

    return this.prefilledChipsValue.find(prefilledChip => String(prefilledChip.value) === String(value))
  }

  _substituteChipPlaceholders(node, mapping) {
    if (node.nodeType === Node.TEXT_NODE) {
      if (node.nodeValue.includes("{{")) {
        node.nodeValue = node.nodeValue.replace(CHIP_PLACEHOLDER_REGEX, (match, name) => {
          return Object.prototype.hasOwnProperty.call(mapping, name) ? mapping[name] : match
        })
      }
      return
    }

    if (node.nodeType === Node.ELEMENT_NODE) {
      for (const attr of Array.from(node.attributes)) {
        if (attr.value.includes("{{")) {
          attr.value = attr.value.replace(CHIP_PLACEHOLDER_REGEX, (match, name) => {
            return Object.prototype.hasOwnProperty.call(mapping, name) ? mapping[name] : match
          })
        }
      }
    }

    for (const child of Array.from(node.childNodes)) {
      this._substituteChipPlaceholders(child, mapping)
    }
  }

  _beforeClearingMultiselectQuery(callback) {
    const display = this.hiddenFieldTarget.dataset.displayForMultiselect
    const value = this.hiddenFieldTarget.dataset.valueForMultiselect

    if (value && !this._fieldValue.has(value)) {
      callback(display, value)
    }

    this.hiddenFieldTarget.dataset.displayForMultiselect = ""
    this.hiddenFieldTarget.dataset.valueForMultiselect = ""
  }

  _resetMultiselectionMarks() {
    if (!this._isMultiselect) return

    this._fieldValueArray.forEach(value => {
      const option = this._optionElementWithValue(value)

      if (option) {
        option.setAttribute("data-multiselected", "")
        option.hidden = true
      }
    })
  }

  _markNotMultiselected(option) {
    if (!this._isMultiselect) return

    option.removeAttribute("data-multiselected")
    option.hidden = false
  }

  _addToFieldValue(value) {
    const newValue = this._fieldValue

    newValue.add(String(value))
    this.hiddenFieldTarget.value = Array.from(newValue).join(",")
    this._syncRequired()

    if (this._isSync) this._resetMultiselectionMarks()
  }

  _removeFromFieldValue(value) {
    const newValue = this._fieldValue

    newValue.delete(String(value))
    this.hiddenFieldTarget.value = Array.from(newValue).join(",")
    this._syncRequired()

    if (this._isSync) this._resetMultiselectionMarks()
  }

  _markMultiPreselected() {
    this.element.dataset.multiPreselected = ""
  }

  get _isMultiselect() {
    return this.hasSelectionChipSrcValue || this._hasChipTemplate
  }

  get _isSingleSelect() {
    return !this._isMultiselect
  }

  get _hasChipTemplate() {
    return !!this._chipTemplate
  }

  get _chipTemplate() {
    return this.element.querySelector("template[data-hw-combobox-chip-template]")
  }

  get _isMultiPreselected() {
    return this.element.hasAttribute("data-multi-preselected")
  }
}
