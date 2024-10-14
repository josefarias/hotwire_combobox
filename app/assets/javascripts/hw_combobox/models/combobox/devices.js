import Combobox from "hw_combobox/models/combobox/base"

Combobox.Devices = Base => class extends Base {
  get _isiOS() {
    return this._isMobileWebkit && !this._isAndroid
  }

  get _isAndroid() {
    return window.navigator.userAgent.includes("Android")
  }

  get _isMobileWebkit() {
    return window.navigator.userAgent.includes("AppleWebKit") && window.navigator.userAgent.includes("Mobile")
  }
}
