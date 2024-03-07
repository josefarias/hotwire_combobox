import Combobox from "hw_combobox/models/combobox/base"
import { wrapAroundAccess } from "hw_combobox/helpers"

Combobox.Selection = Base => class extends Base {
  selectOptionOnClick(event) {
    this.filter(event)
    this._select(event.currentTarget)
    this.close()
  }

  _connectSelection() {
    if (this.hasPrefilledDisplayValue) {
      this._fullQuery = this.prefilledDisplayValue
    }
  }

  _select(option, { forceAutocomplete = false } = {}) {
    this._resetOptions()

    if (option) {
      this._autocompleteWith(option, { force: forceAutocomplete })
      this._commitSelection(option, { selected: true })
      this._markValid()
    } else {
      this._markInvalid()
    }
  }

  _commitSelection(option, { selected }) {
    this._markSelected(option, { selected })

    if (selected) {
      this.hiddenFieldTarget.value = option.dataset.value
      option.scrollIntoView({ block: "nearest" })
    }

    this._dispatchSelectionEvent({ isNew: false })
  }

  _markSelected(option, { selected }) {
    if (this.hasSelectedClass) {
      option.classList.toggle(this.selectedClass, selected)
    }

    option.setAttribute("aria-selected", selected)
    this._setActiveDescendant(selected ? option.id : "")
  }

  _deselect() {
    const option = this._selectedOptionElement

    if (option) this._commitSelection(option, { selected: false })

    this.hiddenFieldTarget.value = null
    this._setActiveDescendant("")

    if (!option) this._dispatchSelectionEvent({ isNew: false })
  }

  _selectNew() {
    this._resetOptions()
    this.hiddenFieldTarget.value = this._fullQuery
    this.hiddenFieldTarget.name = this.nameWhenNewValue
    this._markValid()

    this._dispatchSelectionEvent({ isNew: true })
  }

  _selectIndex(index) {
    const option = wrapAroundAccess(this._visibleOptionElements, index)
    this._select(option, { forceAutocomplete: true })
  }

  _preselectOption() {
    if (this._hasValueButNoSelection && this._allOptions.length < 100) {
      const option = this._allOptions.find(option => {
        return option.dataset.value === this.hiddenFieldTarget.value
      })

      if (option) this._markSelected(option, { selected: true })
    }
  }

  _lockInSelection() {
    if (this._shouldLockInSelection) {
      this._select(this._ensurableOption, { forceAutocomplete: true })
      this.filter({ inputType: "hw:lockInSelection" })
    }

    if (this._isUnjustifiablyBlank) {
      this._deselect()
      this._clearQuery()
    }
  }

  _setActiveDescendant(id) {
    this._forAllComboboxes(el => el.setAttribute("aria-activedescendant", id))
  }

  get _hasValueButNoSelection() {
    return this.hiddenFieldTarget.value && !this._selectedOptionElement
  }

  get _shouldLockInSelection() {
    return this._isQueried && !!this._ensurableOption && !this._isNewOptionWithPotentialMatches
  }

  get _ensurableOption() {
    return this._selectedOptionElement || this._visibleOptionElements[0]
  }
}
