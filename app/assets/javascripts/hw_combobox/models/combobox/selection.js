import Combobox from "hw_combobox/models/combobox/base"
import { wrapAroundAccess, isDeleteEvent } from "hw_combobox/helpers"

Combobox.Selection = Base => class extends Base {
  selectOnClick(event) {
    this._forceSelectionAndFilter(event.currentTarget, event)
    this.close()
  }

  _connectSelection() {
    if (this.hasPrefilledDisplayValue) {
      this._fullQuery = this.prefilledDisplayValue
    }
  }

  _selectOnQuery(inputEvent) {
    if (this._shouldTreatAsNewOptionForFiltering(!isDeleteEvent(inputEvent))) {
      this._selectNew()
    } else if (isDeleteEvent(inputEvent)) {
      this._deselect()
    } else if (inputEvent.inputType === "hw:lockInSelection" && this._ensurableOption) {
      this._selectAndAutocompleteMissingPortion(this._ensurableOption)
    } else if (this._isOpen && this._visibleOptionElements[0]) {
      this._selectAndAutocompleteMissingPortion(this._visibleOptionElements[0])
    } else if (this._isOpen) {
      this._resetOptionsAndNotify()
      this._markInvalid()
    } else {
      // When selecting from an async dialog listbox: selection is forced, the listbox is filtered,
      // and the dialog is closed. Filtering ends with an `endOfOptionsStream` target connected
      // to the now invisible combobox, which is now closed because Turbo waits for "nextRepaint"
      // before rendering turbo streams. This ultimately calls +_selectOnQuery+. We do want
      // to call +_selectOnQuery+ in this case to account for e.g. selection of
      // new options. But we will noop here if it's none of the cases checked above.
    }
  }

  _select(option, autocompleteStrategy) {
    const previousValue = this._fieldValue

    this._resetOptionsSilently()

    autocompleteStrategy(option)

    this._setFieldValue(option.dataset.value)
    this._markSelected(option)
    this._markValid()
    this._dispatchSelectionEvent({ isNewAndAllowed: false, previousValue: previousValue })

    option.scrollIntoView({ block: "nearest" })
  }

  _selectNew() {
    const previousValue = this._fieldValue

    this._resetOptionsSilently()
    this._setFieldValue(this._fullQuery)
    this._setFieldName(this.nameWhenNewValue)
    this._markValid()
    this._dispatchSelectionEvent({ isNewAndAllowed: true, previousValue: previousValue })
  }

  _deselect() {
    const previousValue = this._fieldValue

    if (this._selectedOptionElement) {
      this._markNotSelected(this._selectedOptionElement)
    }

    this._setFieldValue(null)
    this._setActiveDescendant("")

    return previousValue
  }

  _deselectAndNotify() {
    const previousValue = this._deselect()
    this._dispatchSelectionEvent({ isNewAndAllowed: false, previousValue: previousValue })
  }

  _selectIndex(index) {
    const option = wrapAroundAccess(this._visibleOptionElements, index)
    this._forceSelectionWithoutFiltering(option)
  }

  _preselect() {
    if (this._hasValueButNoSelection && this._allOptions.length < 100) {
      const option = this._allOptions.find(option => {
        return option.dataset.value === this._fieldValue
      })

      if (option) this._markSelected(option)
    }
  }

  _selectAndAutocompleteMissingPortion(option) {
    this._select(option, this._autocompleteMissingPortion.bind(this))
  }

  _selectAndAutocompleteFullQuery(option) {
    this._select(option, this._replaceFullQueryWithAutocompletedValue.bind(this))
  }

  _forceSelectionAndFilter(option, event) {
    this._forceSelectionWithoutFiltering(option)
    this._filter(event)
  }

  _forceSelectionWithoutFiltering(option) {
    this._selectAndAutocompleteFullQuery(option)
  }

  _lockInSelection() {
    if (this._shouldLockInSelection) {
      this._forceSelectionAndFilter(this._ensurableOption, { inputType: "hw:lockInSelection" })
    }
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

  _setActiveDescendant(id) {
    this._forAllComboboxes(el => el.setAttribute("aria-activedescendant", id))
  }

  _removeActiveDescendant() {
    this._setActiveDescendant("")
  }

  get _hasValueButNoSelection() {
    return this._fieldValue && !this._selectedOptionElement
  }

  get _shouldLockInSelection() {
    return this._isQueried && !!this._ensurableOption && !this._isNewOptionWithPotentialMatches
  }

  get _ensurableOption() {
    return this._selectedOptionElement || this._visibleOptionElements[0]
  }
}
