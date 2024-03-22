import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "preselectionScratchpad", "preselectionCount", "closedScratchpad", "closedCount", "removalScratchpad", "removalCount" ]

  connect() {
    this.preselectionScratchpadTarget.innerText = "Ready to listen for hw-combobox events!"
  }

  showPreselection(event) {
    this.preselectionCount ??= 0
    this.preselectionCount++
    this.preselectionScratchpadTarget.innerText = this.#template(event)
    this.preselectionCountTarget.innerText = `preselections: ${this.preselectionCount}.`
  }

  showClosed(event) {
    this.closedCount ??= 0
    this.closedCount++
    this.closedScratchpadTarget.innerText = this.#template(event)
    this.closedCountTarget.innerText = `closings: ${this.closedCount}.`
  }

  showRemoval(event) {
    this.removalCount ??= 0
    this.removalCount++
    this.removalScratchpadTarget.innerText = this.#template(event)
    this.removalCountTarget.innerText = `removals: ${this.removalCount}.`
  }

  #template(event) {
    const cast = (string) => {
      let _string = String(string)
      if (_string === "undefined") _string = ""
      return _string || "<empty>"
    }

    return `event: ${cast(event.type)}
      value: ${cast(event.detail.value)}.
      display: ${cast(event.detail.display)}.
      query: ${cast(event.detail.query)}.
      fieldName: ${cast(event.detail.fieldName)}.
      isNewAndAllowed: ${cast(event.detail.isNewAndAllowed)}.
      isValid: ${cast(event.detail.isValid)}.
      previousValue: ${cast(event.detail.previousValue)}.
      removedDisplay: ${cast(event.detail.removedDisplay)}.
      removedValue: ${cast(event.detail.removedValue)}.
    `
  }
}
