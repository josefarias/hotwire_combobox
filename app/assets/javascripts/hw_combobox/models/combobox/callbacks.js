import Combobox from "hw_combobox/models/combobox/base"

const MAX_CALLBACK_ATTEMPTS = 3

Combobox.Callbacks = Base => class extends Base {
  _initializeCallbacks() {
    this.callbackQueue = []
    this.callbackExecutionAttempts = {}
  }

  _enqueueCallback() {
    const callbackId = crypto.randomUUID()
    this.callbackQueue.push(callbackId)
    return callbackId
  }

  _isNextCallback(callbackId) {
    return this._nextCallback === callbackId
  }

  _callbackAttemptsExceeded(callbackId) {
    return this._callbackAttempts(callbackId) > MAX_CALLBACK_ATTEMPTS
  }

  _callbackAttempts(callbackId) {
    return this.callbackExecutionAttempts[callbackId] || 0
  }

  _recordCallbackAttempt(callbackId) {
    this.callbackExecutionAttempts[callbackId] = this._callbackAttempts(callbackId) + 1
  }

  _dequeueCallback(callbackId) {
    this.callbackQueue = this.callbackQueue.filter(id => id !== callbackId)
    this._forgetCallbackExecutionAttempts(callbackId)
  }

  _forgetCallbackExecutionAttempts(callbackId) {
    delete this.callbackExecutionAttempts[callbackId]
  }

  get _nextCallback() {
    return this.callbackQueue[0]
  }
}
