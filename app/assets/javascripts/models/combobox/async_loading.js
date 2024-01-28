import Combobox from "models/combobox/base"

Combobox.AsyncLoading = Base => class extends Base {
  get _isAsync() {
    return this.hasAsyncSrcValue
  }
}
