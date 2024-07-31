import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = [ "hw-combobox" ]

  clear(event) {
    this.hwComboboxOutlets.forEach(outlet => outlet.clear(event))
  }
}
