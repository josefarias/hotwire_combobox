
import Combobox from "models/combobox/base"
import { applyFilter } from "helpers"

Combobox.Filtering = Base => class extends Base {
  filter(event) {
    const isDeleting = event.inputType === "deleteContentBackward"
    const query = this._actingCombobox.value.trim()

    this.open()

    this._allOptionElements.forEach(applyFilter(query, { matching: this.filterableAttributeValue }))

    if (this._isValidNewOption(query, { ignoreAutocomplete: isDeleting })) {
      this._selectNew(query)
    } else if (isDeleting) {
      this._deselect(this._selectedOptionElement)
    } else {
      this._select(this._visibleOptionElements[0])
    }
  }
}
