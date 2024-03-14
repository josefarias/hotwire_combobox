import Combobox from "hw_combobox/models/combobox/base"
import { wrapAroundAccess } from "hw_combobox/helpers"

Combobox.Selection = Base => class extends Base {
  selectOptionOnClick(event) {
    this.filter(event)
    this._selectAndReplaceFullQuery(event.currentTarget)
    this.close()
  }

  _connectSelection() {
    if (this.hasPrefilledDisplayValue) {
      this._fullQuery = this.prefilledDisplayValue
    }
  }

  _selectAndReplaceFullQuery(option) {
    this._select(option, this._replaceFullQueryWithAutocompletedValue.bind(this))
  }

  _selectAndAutocompleteMissingPortion(option) {
    this._select(option, this._autocompleteMissingPortionOnly.bind(this))
  }

  _select(option, autocompleteStrategy) {
    this._resetOptions()

    if (option) {
      const previousValue = this._value

      autocompleteStrategy(option)

      this._setValue(option.dataset.value)
      this._markSelected(option)
      this._markValid()
      this._dispatchSelectionEvent({ isNewAndAllowed: false, previousValue: previousValue })

      option.scrollIntoView({ block: "nearest" })
    } else {
      this._markInvalid()
    }
  }

  _selectNew() {
    const previousValue = this._value

    this._resetOptions()
    this._setValue(this._fullQuery)
    this._setName(this.nameWhenNewValue)
    this._markValid()
    this._dispatchSelectionEvent({ isNewAndAllowed: true, previousValue: previousValue })
  }

  _deselect() {
    const previousValue = this._value

    if (this._selectedOptionElement) {
      this._markNotSelected(this._selectedOptionElement)
    }

    this._setValue(null)
    this._setActiveDescendant("")
    this._dispatchSelectionEvent({ isNewAndAllowed: false, previousValue: previousValue })
  }

  _markSelected(option) {
    if (this.hasSelectedClass) option.classList.add(this.selectedClass)
    option.setAttribute("aria-selected", true)
    this._setActiveDescendant(option.id)
  }

  _markNotSelected(option) {
    if (this.hasSelectedClass) option.classList.remove(this.selectedClass)
    option.removeAttribute("aria-selected")
    this._removeActiveDescendant()
  }

  _selectIndex(index) {
    const option = wrapAroundAccess(this._visibleOptionElements, index)
    this._selectAndReplaceFullQuery(option)
  }

  _preselectOption() {
    if (this._hasValueButNoSelection && this._allOptions.length < 100) {
      const option = this._allOptions.find(option => {
        return option.dataset.value === this._value
      })

      if (option) this._markSelected(option)
    }
  }

  _lockInSelection() {
    if (this._shouldLockInSelection) {
      this._selectAndReplaceFullQuery(this._ensurableOption)
      this.filter({ inputType: "hw:lockInSelection" })
    }
  }

  _setActiveDescendant(id) {
    this._forAllComboboxes(el => el.setAttribute("aria-activedescendant", id))
  }

  _removeActiveDescendant() {
    this._setActiveDescendant("")
  }

  _setValue(value) {
    this.hiddenFieldTarget.value = value
  }

  _setName(value) {
    this.hiddenFieldTarget.name = value
  }

  get _value() {
    return this.hiddenFieldTarget.value
  }

  get _hasValueButNoSelection() {
    return this._value && !this._selectedOptionElement
  }

  get _shouldLockInSelection() {
    return this._isQueried && !!this._ensurableOption && !this._isNewOptionWithPotentialMatches
  }

  get _ensurableOption() {
    return this._selectedOptionElement || this._visibleOptionElements[0]
  }
}
