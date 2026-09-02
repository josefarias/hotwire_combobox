import Combobox from "hw_combobox/models/combobox/base"

Combobox.AsyncLoading = Base => class extends Base {
  asyncSrcValueChanged(current, previous) {
    if (!previous || current === previous) return

    this._retirePendingPage()
    this._filter()
  }

  _retirePendingPage() {
    this.endOfOptionsStreamTargets.forEach(element => element.remove())
  }

  get _isAsync() {
    return this.hasAsyncSrcValue
  }

  get _isSync() {
    return !this._isAsync
  }
}
