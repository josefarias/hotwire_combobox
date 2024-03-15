import Combobox from "hw_combobox/models/combobox/base"

Combobox.AsyncLoading = Base => class extends Base {
  get _isAsync() {
    return this.hasAsyncSrcValue
  }

  get _isSync() {
    return !this._isAsync
  }
}
