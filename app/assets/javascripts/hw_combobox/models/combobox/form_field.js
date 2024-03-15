import Combobox from "hw_combobox/models/combobox/base"

Combobox.FormField = Base => class extends Base {
  _setFieldValue(value) {
    this.hiddenFieldTarget.value = value
  }

  _setFieldName(value) {
    this.hiddenFieldTarget.name = value
  }

  get _fieldValue() {
    return this.hiddenFieldTarget.value
  }

  get _fieldName() {
    return this.hiddenFieldTarget.name
  }
}
