import Combobox from "hw_combobox/models/combobox/base"

Combobox.Actors = Base => class extends Base {
  _initializeActors() {
    this._actingListbox = this.listboxTarget
    this._actingCombobox = this.comboboxTarget
  }

  get _actingListbox() {
    return this.actingListbox
  }

  set _actingListbox(listbox) {
    this.actingListbox = listbox
  }

  get _actingCombobox() {
    return this.actingCombobox
  }

  set _actingCombobox(combobox) {
    this.actingCombobox = combobox
  }

  get _allComboboxes() {
    return [ this.comboboxTarget, this.dialogComboboxTarget ]
  }
}
