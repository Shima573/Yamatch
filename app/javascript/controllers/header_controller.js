import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    const header = this.element
    addEventListener("scroll", () => {
      if (scrollY > 10) {
        header.classList.add("is-scrolled");
      } else {
        header.classList.remove("is-scrolled");
      }
    });
  }

  toggle() {
    this.element.classList.toggle("is-open")
    this.menuTarget.classList.toggle("hidden")
  }
}
