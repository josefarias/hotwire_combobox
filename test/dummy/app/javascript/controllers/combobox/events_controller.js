import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "selectionScratchpad", "selectionCount", "closedScratchpad", "closedCount" ]

  connect() {
    this.selectionScratchpadTarget.innerText = "Ready to listen for hw-combobox events!"
  }

  showSelection(event) {
    this.selectionCount ??= 0
    this.selectionCount++
    this.selectionScratchpadTarget.innerText = this.#template(event)
    this.selectionCountTarget.innerText = `selections: ${this.selectionCount}.`
  }

  showClosed(event) {
    this.closedCount ??= 0
    this.closedCount++
    this.closedScratchpadTarget.innerText = this.#template(event)
    this.closedCountTarget.innerText = `closings: ${this.closedCount}.`
  }

  #template(event) {
    const cast = (string) => {
      let _string = String(string)
      if (_string === "undefined") _string = ""
      return _string || "<empty>"
    }

    return `event: ${cast(event.type) || "<empty>"}
      value: ${cast(event.detail.value) || "<empty>"}
      display: ${cast(event.detail.display) || "<empty>"}
      query: ${cast(event.detail.query) || "<empty>"}
      fieldName: ${cast(event.detail.fieldName) || "<empty>"}
      isNewAndAllowed: ${cast(event.detail.isNewAndAllowed) || "<empty>"}
      isValid: ${cast(event.detail.isValid) || "<empty>"}
      previousValue: ${cast(event.detail.previousValue) || "<empty>"}
    `
  }
}
