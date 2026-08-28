import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="companion-count"
export default class extends Controller {
  static targets = ["input"]
  connect() {
  }

  increment() {
    let count = Number(this.inputTarget.value)
    count += 1
    this.inputTarget.value = count
  }

  decrement() {
    let count = Number(this.inputTarget.value)
    if (count > 1) {
      count -= 1
    }
    this.inputTarget.value = count
  }
}
