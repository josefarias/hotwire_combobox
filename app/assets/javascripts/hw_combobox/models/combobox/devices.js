import Combobox from "hw_combobox/models/combobox/base"

Combobox.Devices = Base => class extends Base {
  _initializeDevice() {
    this.element.classList.toggle("hw-combobox--ios", this._isiOS)
    this.element.classList.toggle("hw-combobox--android", this._isAndroid)
    this.element.classList.toggle("hw-combobox--mobile-webkit", this._isMobileWebkit)
  }

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
